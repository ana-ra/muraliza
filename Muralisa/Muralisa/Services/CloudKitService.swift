//
// modelCloudKit.swift
// Muralisa
//
// Created by Silvana Rodrigues Alves on 15/10/24.

import Foundation
import CloudKit
import UIKit
import CoreLocation
import SwiftUICore

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
    
    func fetchRecordByTags(_ tags: [String], except exceptionRecordName: String) async throws -> [CKRecord] {
        let exceptionRecordID = CKRecord.ID(recordName: exceptionRecordName)
        let predicate = NSPredicate(format: "ANY Tag IN %@ AND recordID != %@ AND Status == 1", tags, exceptionRecordID)
        
        let query = CKQuery(recordType: "Artwork", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 9
        queryOperation.desiredKeys = ["Image_thumbnail"]
        
        
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
        }
    }
    
    
//    func fetchRecordsByType(_ recordType: String, predicate: NSPredicate = NSPredicate(value: true)) async throws -> [CKRecord] {
//        let query = CKQuery(recordType: recordType, predicate: predicate)
//        let results = try await databasePublic.records(matching: query)
//        return results.matchResults.compactMap { try? $0.1.get() }
//    }
//    
    func fetchRecordsByType(_ recordType: String, predicate: NSPredicate = NSPredicate(value: true), desiredKeys: [String]? = nil) async throws -> [CKRecord] {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        if recordType == Work.recordType {
            queryOperation.desiredKeys = ["Image_thumbnail"] // Fetch only the thumbnail field
        }

        var fetchedRecords: [CKRecord] = []

        return try await withCheckedThrowingContinuation { continuation in
            queryOperation.recordMatchedBlock = { recordID, recordResult in
                switch recordResult {
                case .success(let record):
                    fetchedRecords.append(record)
                case .failure(let error):
                    print("Error fetching record \(recordID): \(error.localizedDescription)")
                }
            }

            queryOperation.queryResultBlock = { result in
                switch result {
                case .success:
                    continuation.resume(returning: fetchedRecords)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            databasePublic.add(queryOperation)
        }
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
    
    func saveRecord(_ record: CKRecord) async throws -> CKRecord {
        try await withCheckedThrowingContinuation { continuation in
            databasePublic.save(record) { returnedRecord, returnedError in
                if let returnedError = returnedError {
                    continuation.resume(throwing: returnedError) // Resume with an error if there was one
                } else if let returnedRecord = returnedRecord {
                    continuation.resume(returning: returnedRecord) // Resume with the saved record
                } else {
                    continuation.resume(throwing: CKError(.unknownItem)) // Handle unexpected nil response gracefully
                }
            }
        }
    }
    
    func fetchRecordsByArtistExceptOne(artistsReference: [CKRecord.Reference], except expectionRecordName: String) async throws -> [CKRecord] {
        var resultArray: [CKRecord] = []
        
        let exceptionRecordID = CKRecord.ID(recordName: expectionRecordName)
        let predicate = NSPredicate(format: "ANY Artist in %@ AND recordID != %@ AND Status == 1", artistsReference, exceptionRecordID)
        let query = CKQuery(recordType: Work.recordType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 6
        queryOperation.desiredKeys = ["Image_thumbnail"]
        
        return try await withCheckedThrowingContinuation { continuation in
            queryOperation.recordMatchedBlock = { (id,record) in
                switch record {
                case .success(let result):
                    resultArray.append(result)
                case .failure(let error):
                    print("error fetching records by distance: \(error)")
                }
                
            }
            
            queryOperation.queryResultBlock = { result in
                switch result {
                case .success:
                    continuation.resume(returning: resultArray)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
            // Execute the query operation
            databasePublic.add(queryOperation)
        }
    }
    
    func fetchSingleWorkExcluding(recordNamesToExclude: [String], completion: @escaping (CKRecord?) -> Void) {
        // Converts all record names to recordIDs
        let recordIDs = recordNamesToExclude.map { CKRecord.ID(recordName: $0) }
        // Predicate logic searches for all records that are not in the recordIDs list
        let predicate = NSPredicate(format: "NOT (recordID IN %@) AND Status == 1", recordIDs)
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
    
    func fetchRecordsByDistance(ofType recordType: String, userPosition: CLLocation?, radius: CGFloat) async throws -> [CKRecord] {
        var resultArray: [CKRecord] = []
        
        guard let location = userPosition else { return resultArray }
        
        let predicate = NSPredicate(format: "distanceToLocation:fromLocation:(Location, %@) < %f AND Status == 1", location, radius)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 6
        queryOperation.desiredKeys = ["Image_thumbnail"]
        
        return try await withCheckedThrowingContinuation { continuation in
            queryOperation.recordMatchedBlock = { (id,record) in
                switch record {
                case .success(let result):
                    resultArray.append(result)
                case .failure(let error):
                    print("error fetching records by distance: \(error)")
                }
                
            }
            
            queryOperation.queryResultBlock = { result in
                switch result {
                case .success:
                    continuation.resume(returning: resultArray)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
            databasePublic.add(queryOperation)
        }
    }
    
    // Helper function to fetch records
    func fetchRecordsByIDsAndDesiredKeys(by recordIDs: [CKRecord.ID], desiredKeys: [String]) async throws -> [CKRecord] {
        return try await withCheckedThrowingContinuation { continuation in
            var fetchedRecords: [CKRecord] = []
            
            let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
            operation.desiredKeys = desiredKeys
            operation.perRecordResultBlock = { recordID, result in
                switch result {
                case .success(let record):
                    fetchedRecords.append(record)
                case .failure(let error):
                    print("Failed to fetch record \(recordID): \(error)")
                }
            }
            
            operation.fetchRecordsResultBlock = { result in
                switch result {
                case .success:
                    continuation.resume(returning: fetchedRecords)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
            // Execute the operation
            databasePublic.add(operation)
        }
    }
    
    // Helper function to save records
    func modifyRecords(_ records: [CKRecord]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let modifyOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            
            modifyOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
            // Execute the operation
            databasePublic.add(modifyOperation)
        }
    }
}
