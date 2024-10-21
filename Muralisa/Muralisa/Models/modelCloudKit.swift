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
        
        // For every element in results, we try to convert the CKRecord, and then return only the non-nil results
        let records = results.matchResults.compactMap { try? convertRecordToArtist($0.1.get()) }
        return records
        
    }
    
    func fetchWorks() async throws -> [Work] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Work.recordType, predicate: predicate)
        let results = try await databasePublic.records(matching: query)
        
        // For every element in results, we try to convert the CKRecord, and then return only the non-nil results
        
        var records: [Work] = []
        let ckRecords = results.matchResults.compactMap { try? $0.1.get() }
        // Can Throw Error
        for record in ckRecords {
            let work = try await convertRecordToWork(record)
            records.append(work)
        }
        return records
    }
    
    func fetchArtistRecordFromReference(from reference: CKRecord.Reference?) async throws -> Artist {
        guard let recordID = reference?.recordID else {
            throw ArtistFetchError.invalidReference
        }
        let record = try await databasePublic.record(for: recordID)
        return convertRecordToArtist(record)
    }
    
    func convertRecordToArtist(_ record: CKRecord) -> Artist {
        let id = UUID() // Cria um UUID único para o artista
        let name = record["Nickname"] as? String ?? "Unknown Artist"
        let biography = record["Biography"] as? String
        var photo: UIImage? = nil
        if let photoAsset = record["Photo"] as? CKAsset,
           let url = photoAsset.fileURL {
            if let photoData = try? Data(contentsOf: url) {
                photo = UIImage(data: photoData)
            }
        }
        return Artist(id: id, name: name, image: photo, biography: biography, works: [])
    }
    
    func convertRecordToWork(_ record: CKRecord) async throws -> Work {
        let id = UUID() // Cria um UUID para a obra
        let title = record["Title"] as? String ?? "Unknown Title"
        let description = record["Description"] as? String ?? "No Description"
        let tag = record["Tag"] as? [String] ?? ["No tags"]
        var image: UIImage? = nil
        if let imageAsset = record["Image"] as? CKAsset,
           let url = imageAsset.fileURL {
            if let imageData = try? Data(contentsOf: url) {
                image = UIImage(data: imageData)
            } else {
                image = UIImage(systemName: "custom.photo.slash")
            }
        }
        let location = record["Location"] as? CLLocation
        let artistReference = record["Artist"] as? CKRecord.Reference
        let artist: Artist?
        
        // Fetch the artist record, handling any potential errors
        if let reference = artistReference {
            artist = try await fetchArtistRecordFromReference(from: reference)
        } else {
            artist = nil
        }
        
        return Work(
            id: id,
            title: title,
            description: description,
            image: image!,
            location: location!,
            tag: tag,
            artist: artist
        )
    }
}
