//
// modelCloudKit.swift
// Muralisa
//
// Created by Silvana Rodrigues Alves on 15/10/24.

import Foundation
import CloudKit
import UIKit

enum FetchError: Error {
    case invalidReference
    case recordNotFound
}

class CloudKitService {
    let container = CKContainer(identifier: "iCloud.muralisa2")
    let databasePublic: CKDatabase
    static var currentModel = CloudKitService()
    
    init() {
        self.databasePublic = container.publicCloudDatabase
    }
    
    func fetchRecordByTags(_ tags: [String]) async throws -> [CKRecord] {
            let predicate = NSPredicate(format: "ANY Tag IN %@", tags)
            
            let query = CKQuery(recordType: "Artwork", predicate: predicate)
            let queryOperation = CKQueryOperation(query: query)
            queryOperation.resultsLimit = 9
            
            
            var fetchedRecords: [CKRecord] = []
            
            return try await withCheckedThrowingContinuation { continuation in
                // Substituto para recordFetchedBlock - processa cada registro individualmente
                queryOperation.recordMatchedBlock = { recordID, recordResult in
                    switch recordResult {
                    case .success(let record):
                        fetchedRecords.append(record)
                    case .failure(let error):
                        print("Erro ao buscar registro \(recordID): \(error.localizedDescription)")
                    }
                }
                
                // Substituto para queryCompletionBlock - lida com o término da consulta
                queryOperation.queryResultBlock = { result in
                    switch result {
                    case .success:
                        continuation.resume(returning: fetchedRecords)  // Retorna registros recuperados
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
                
                // Adiciona a operação ao banco de dados público
                
                databasePublic.add(queryOperation)
                
                
            }}
    
    
    func fetchRecordsByType(_ recordType: String, predicate: NSPredicate = NSPredicate(value: true)) async throws -> [CKRecord] {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let results = try await databasePublic.records(matching: query)
        return results.matchResults.compactMap { try? $0.1.get() }
    }

    func fetchRecordFromReference(from reference: CKRecord.Reference?) async throws -> CKRecord {
        guard let recordID = reference?.recordID else {
            throw FetchError.invalidReference
        }
        return try await databasePublic.record(for: recordID)
    }
    
    func updateRecordField(recordName: String, newValue: Any, forKey key: String) {
        let recordID = CKRecord.ID(recordName: recordName)
        
        // Fetch the existing record
        databasePublic.fetch(withRecordID: recordID) { record, error in
            if let error = error {
                print("Error fetching record: \(error.localizedDescription)")
                return
            }
            
            if let record = record {
                // Update the field
                record.setValue(newValue, forKey: key)
                
                // Save the modified record
                self.databasePublic.save(record) { savedRecord, saveError in
                    if let saveError = saveError {
                        print("Error saving record: \(saveError.localizedDescription)")
                    } else {
                        print("Record updated successfully")
                    }
                }
            }
        }
    }
    
    func fetchRecordFromRecordName(from recordName: String) async throws -> CKRecord {
        let recordID = CKRecord.ID(recordName: recordName)
        return try await databasePublic.record(for: recordID)
    }
    
    func fetchSingleWorkExcluding(recordNamesToExclude: [String], completion: @escaping (CKRecord?) -> Void) {
        // Converts all record names to recordIDs
        let recordIDs = recordNamesToExclude.map { CKRecord.ID(recordName: $0) }
        // Predicate logic searches for all records that are not in the recordIDs list
        let predicate = NSPredicate(format: "NOT (recordID IN %@)", recordIDs)
        let query = CKQuery(recordType: Work.recordType, predicate: predicate)
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1  // Limit to one record
        
        queryOperation.recordFetchedBlock = { record in
            completion(record)  // Return the fetched record
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                print("Error fetching record: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        databasePublic.add(queryOperation)
    }
}
