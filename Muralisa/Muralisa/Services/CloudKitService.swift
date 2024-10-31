//
// modelCloudKit.swift
// Muralisa
//
// Created by Silvana Rodrigues Alves on 15/10/24.

import Foundation
import CloudKit
import UIKit
import CoreLocation

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
    
    func fetchRecordsByType(_ recordType: String) async throws -> [CKRecord] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let results = try await databasePublic.records(matching: query)
        return results.matchResults.compactMap { try? $0.1.get() }
    }

    func fetchRecordsByDistance(distanceInMeters: CGFloat) async throws -> [CKRecord] {
        let location = CLLocation(latitude: -22.824721, longitude: 47.080082)
//        let predicate = NSPredicate(format: "distanceToLocation:fromLocation:(Location, %@) < %f", location, distanceInMeters)
        
        let predicate = NSPredicate(format: "distanceToLocation:fromLocation:(Location, %@) < %f", location, Variables().distanceToCloseArtworks)
        
        let query = CKQuery(recordType: "Artwork", predicate: predicate)
        let results = try await databasePublic.records(matching: query)
        
        //TODO: limitar a quantidade de obras requisitas pra 6
        return results.matchResults.compactMap { try? $0.1.get() }
    }
    
    func fetchRecordFromReference(from reference: CKRecord.Reference?) async throws -> CKRecord {
        guard let recordID = reference?.recordID else {
            throw FetchError.invalidReference
        }
        return try await databasePublic.record(for: recordID)
    }
    
    func fetchRecordFromRecordName(from recordName: String) async throws -> CKRecord {
        let recordID = CKRecord.ID(recordName: recordName)
        return try await databasePublic.record(for: recordID)
    }
}
