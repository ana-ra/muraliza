//
//  modelCloudKit.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.

import Foundation
import CloudKit
import UIKit

class ModelCloudKit {
    let container = CKContainer.init(identifier: "iCloud.muralisa")
    let databasePublic: CKDatabase
    
    static var currentModel = ModelCloudKit()
    
    init() {
        self.databasePublic = container.publicCloudDatabase
    }
    
    // Função para buscar todos os artistas e converter CKRecord para Artist
    func fetchArtists(_ completion: @escaping (Result<[Artist], Error>) -> Void) {
        let predicate = NSPredicate(value: true) // Busca todos os registros
        let query = CKQuery(recordType: Artist.recordType, predicate: predicate)
        
        databasePublic.perform(query, inZoneWith: CKRecordZone.default().zoneID) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let result = results else { return }
            
            // Converter os CKRecords para objetos Artist
            let artists = result.compactMap { self.convertRecordToArtist($0) }
            
            DispatchQueue.main.async {
                completion(.success(artists))
            }
        }
    }
    
    // Função para converter CKRecord para Artist
    func convertRecordToArtist(_ record: CKRecord) -> Artist {
        let id = UUID() // Cria um UUID único para o artista
        let name = record["Name"] as? String ?? "Unknown Artist"
        let biography = record["Biography"] as? String
        
        // Recebe foto como CKAsset, converte para Data e depois converte para UIImage
        var photo: UIImage? = nil
        if let photoAsset = record["Photo"] as? CKAsset,
           let url = photoAsset.fileURL {
            if let photoData = try? Data(contentsOf: url) {
                photo = UIImage(data: photoData)
            }
        }

        // Retorna o objeto Artist
        return Artist(id: id, name: name, image: photo, biography: biography, works: [])
    }
    
    func fetchWorks(for artist: Artist, completion: @escaping (Result<[Work], Error>) -> Void) {
        let artistRecordID = CKRecord.ID(recordName: artist.id.uuidString)
        let artistReference = CKRecord.Reference(recordID: artistRecordID, action: .none)
        
        let predicate = NSPredicate(format: "Artist == %@", artistReference)
        let query = CKQuery(recordType: Work.recordType, predicate: predicate)
        
        databasePublic.perform(query, inZoneWith: CKRecordZone.default().zoneID) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let result = results else { return }
            
            let works = result.compactMap { self.convertRecordToWork($0) }
            
            DispatchQueue.main.async {
                completion(.success(works))
            }
        }
    }
    
    func convertRecordToWork(_ record: CKRecord) -> Work {
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

        let artistID = artistReference?.recordID.recordName

        return Work(
            id: id,
            title: title,
            description: description,
            image: image!,
            location: location!,
            tag: tag,
            artistID: UUID(uuidString: artistID ?? "")
        )
    }
}

    

