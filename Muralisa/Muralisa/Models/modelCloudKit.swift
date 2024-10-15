//
//  modelCloudKit.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//
import Foundation
import CloudKit

class ModelCloudKit {
    
    let container: CKContainer
    let databasePublic: CKDatabase
    
    static var currentModel = ModelCloudKit()
    
    init() {
        container = CKContainer.default()
        databasePublic = container.publicCloudDatabase
    }
    
    // Fetch Artists from CloudKit
    func fetchArtists(_ completion: @escaping (Result<[Artist], Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Artist", predicate: predicate)
        
        databasePublic.perform(query, inZoneWith: CKRecordZone.default().zoneID) { results, errors in
            if let error = errors {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let result = results else { return }
            
            let artists = result.compactMap {
                Artist(record: $0)
            }
            
            DispatchQueue.main.async {
                completion(.success(artists))
            }
        }
    }
    
    // Fetch Works from CloudKit
    func fetchWorks(_ completion: @escaping (Result<[Work], Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Work", predicate: predicate)
        
        databasePublic.perform(query, inZoneWith: CKRecordZone.default().zoneID) { results, errors in
            if let error = errors {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let result = results else { return }
            
            let works = result.compactMap {
                Work(record: $0)
            }
            
            DispatchQueue.main.async {
                completion(.success(works))
            }
        }
    }
}
