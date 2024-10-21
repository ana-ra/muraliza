//
// modelCloudKit.swift
// Muralisa
//
// Created by Silvana Rodrigues Alves on 15/10/24.

import Foundation
import CloudKit
import UIKit

enum ArtistFetchError: Error {
    case invalidReference
    case recordNotFound
}

class ModelCloudKit {
    let container = CKContainer(identifier: "iCloud.muralisa")
    let databasePublic: CKDatabase
    static var currentModel = ModelCloudKit()
    
    init() {
        self.databasePublic = container.publicCloudDatabase
    }
    
    func fetchArtists() async throws -> [Artist] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Artist.recordType, predicate: predicate)
        let results = try await databasePublic.records(matching: query)
        
        let records = results.matchResults.compactMap { try? convertRecordToArtist($0.1.get()) }
        return records
    }
    
    func fetchWorks() async throws -> [Work] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Work.recordType, predicate: predicate)
        let results = try await databasePublic.records(matching: query)
        
        var records: [Work] = []
        let ckRecords = results.matchResults.compactMap { try? $0.1.get() }
        
        for record in ckRecords {
            print("Work Record: \(record)")
            
            let work = try await convertRecordToWork(record)
            
            print("Converted Work: \(work)")
            
            records.append(work)
        }
        return records
    }
    
    func fetchRecordFromReference(from reference: CKRecord.Reference?) async throws -> CKRecord {
        guard let recordID = reference?.recordID else {
            throw ArtistFetchError.invalidReference
        }
        let record = try await databasePublic.record(for: recordID)
        return record
        
    }
    
    func fetchWorkFromReference(from reference: String) async throws -> Work {
        let recordID = CKRecord.ID(recordName: reference)
        
        let record = try await databasePublic.record(for: recordID)
        
        let work = try await convertRecordToWork(record)
        
        return work
    }
    
    
    func convertRecordToArtist(_ record: CKRecord) -> Artist {
        let id = UUID() // Generate a UUID for the artist
        let name = record["Nickname"] as? String ?? "Unknown Artist"
        let biography = record["Biography"] as? String
        var photo: UIImage? = nil
        if let photoAsset = record["Photo"] as? CKAsset,
           let url = photoAsset.fileURL {
            if let photoData = try? Data(contentsOf: url) {
                photo = UIImage(data: photoData)
            }
        }
        
        // Primeiro, obter a lista de referências de obras
        var worksReferences: [CKRecord.Reference] = []
        if let references = record["Work"] as? [CKRecord.Reference] {
            worksReferences = references
        }
        
        // Depois, converter essas referências para strings (normalmente o recordID)
        let worksReferencesStrings = worksReferences.map { $0.recordID.recordName }
        
        return Artist(id: id, name: name, image: photo, biography: biography, works: worksReferencesStrings)
    }
    
    func convertRecordToWork(_ record: CKRecord) async throws -> Work {
        let id = UUID() // Generate a UUID for the work
        let title = record["Title"] as? String ?? "Unknown Title"
        let description = record["Description"] as? String ?? "No Description"
        let tag = record["Tag"] as? [String] ?? ["No tags"]
        
        // Handle image loading
        var image: UIImage? = nil
        if let imageAsset = record["Image"] as? CKAsset,
           let url = imageAsset.fileURL {
            if let imageData = try? Data(contentsOf: url) {
                image = UIImage(data: imageData)
            } else {
                image = UIImage(systemName: "custom.photo.slash")
            }
        }
        
        let location = record["Location"] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        
        let artistReference = record["Artist"] as? CKRecord.Reference
        var artist: Artist? = nil
        
        if let reference = artistReference {
            let artistRecord = try await fetchRecordFromReference(from: reference)
            artist = convertRecordToArtist(artistRecord)
        } else {
            print("Obra sem referência de artista: \(title)")
        }
        
        return Work(
            id: id,
            title: title,
            description: description,
            image: image ?? UIImage(systemName: "photo.badge.exclamationmark")!,
            location: location,
            tag: tag,
            artist: artist
        )
    }
}
