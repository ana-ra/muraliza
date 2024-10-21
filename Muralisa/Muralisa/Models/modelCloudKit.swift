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
        do {
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
        } catch {
            // Print the error if something goes wrong while fetching works
            print("Erro ao buscar obras: \(error)")
            throw error
        }
    }
    
    func fetchArtistRecordFromReference(from reference: CKRecord.Reference?) async throws -> Artist {
        guard let recordID = reference?.recordID else {
            throw ArtistFetchError.invalidReference
        }
        do {
            let record = try await databasePublic.record(for: recordID)
            return convertRecordToArtist(record)
        } catch {
            // Print error if something goes wrong while fetching the artist record
            print("Erro ao buscar artista: \(error)")
            throw ArtistFetchError.recordNotFound
        }
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
        return Artist(id: id, name: name, image: photo, biography: biography, works: [])
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
        
        do {
            if let reference = artistReference {
                artist = try await fetchArtistRecordFromReference(from: reference)
            } else {
                print("Obra sem referência de artista: \(title)")
            }
        } catch {
            print("Erro ao buscar o artista associado à obra \(title): \(error)")
            artist = nil
        }
        
        return Work(
            id: id,
            title: title,
            description: description,
            image: image ?? UIImage(systemName: "custom.photo.slash")!,
            location: location,
            tag: tag,
            artist: artist
        )
    }
}
