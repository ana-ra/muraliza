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

    func fetchRecordsByDistance(userPosition: CLLocation?) -> [CKRecord] {
        var resultArray: [CKRecord] = []
        
        guard let location = userPosition else {return resultArray}
        
        let predicate = NSPredicate(format: "distanceToLocation:fromLocation:(Location, %@) < %f", location, Constants().distanceToCloseArtworks)
        let query = CKQuery(recordType: Work.recordType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.resultsLimit = 6

        queryOperation.recordFetchedBlock = { record in
            resultArray.append(record)
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                print("Error fetching record: \(error.localizedDescription)")
                return
            }
        }
        
        queryOperation.recordMatchedBlock = { (id,record) in
            if case .success(let result) = record {
                print("record: \(record)")
                resultArray.append(result)
            }
            if case .failure(let error) = record {
                print("error fetching records by distance: \(error)")
            }
        }
        
        databasePublic.add(queryOperation)
        print("fetchRecordsByDistance: \(resultArray)")
        return resultArray
    }
    
}
