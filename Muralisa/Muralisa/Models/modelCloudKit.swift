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
    
    func fetchArtists(_ completion: @escaping (Result<[Artist], Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Artist.recordType, predicate: predicate)
        
        databasePublic.perform(query, inZoneWith: CKRecordZone.default().zoneID) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let result = results else { return }
            
            let artists = result.compactMap { Artist(record: $0) }
            
            DispatchQueue.main.async {
                completion(.success(artists))
            }
        }
    }
    
    func fetchWorks(for artist: Artist, completion: @escaping (Result<[Work], Error>) -> Void) {
        let reference = CKRecord.Reference(recordID: artist.id, action: .none)
        let predicate = NSPredicate(format: "Artist == %@", reference)
        let query = CKQuery(recordType: Work.recordType, predicate: predicate)
        
        databasePublic.perform(query, inZoneWith: CKRecordZone.default().zoneID) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let result = results else { return }
            
            let works = result.compactMap { Work(record: $0) }
            
            DispatchQueue.main.async {
                completion(.success(works))
            }
        }
    }
}
