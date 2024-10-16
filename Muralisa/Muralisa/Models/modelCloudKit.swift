//
//  modelCloudKit.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.

import Foundation
import CloudKit
import UIKit

class ModelCloudKit {
    
    let container: CKContainer
    let databasePublic: CKDatabase
    
    static var currentModel = ModelCloudKit()
    
    init() {
        container = CKContainer.default()
        databasePublic = container.publicCloudDatabase
    }
    
    // Função para buscar todos os artistas e converter CKRecord para Artist
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
            
            // Converter os CKRecords para objetos Artist
            let artists = result.compactMap { self.convertRecordToArtist($0) }
            
            DispatchQueue.main.async {
                completion(.success(artists))
            }
        }
    }
    
    // Função para converter CKRecord para Artist
    func convertRecordToArtist(_ record: CKRecord) -> Artist {
        let id = UUID()
        let name = record["name"] as? String ?? "Unknown Artist"
        let biography = record["biography"] as? String
        let photo = record["photo"] as? UIImage
        let works = (record["works"] as? [Work])!
        
        return Artist(id: id, name: name, image: photo, biography: biography, works: works)
    }

    // Função para buscar todas as obras relacionadas a um artista
    func fetchWorks(for artist: Artist, completion: @escaping (Result<[Work], Error>) -> Void) {
        let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: artist.id.uuidString), action: .none)
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
            
            // Converter os CKRecords para objetos Work
            let works = result.compactMap { self.convertRecordToWork($0) }
            
            DispatchQueue.main.async {
                completion(.success(works))
            }
        }
    }
    
    // Função para converter CKRecord para Work
    func convertRecordToWork(_ record: CKRecord) -> Work {
        let id = UUID() // Cria um UUID para a obra
        let title = record["title"] as? String ?? "Unknown Title"
        let description = record["description"] as? String ?? "No Description"
        let tag = record["tag"] as? [String] ?? ["No tags"]
        let image = (record["image"] as? UIImage ?? UIImage(systemName: "custom.photo.slash"))!
        let location = (record["location"] as? CLLocation)!
        let artistReference = record["Artist"] as? CKRecord.Reference
        
        // Se tiver referência a um artista, cria o UUID com base no recordName
        let artistID = artistReference.map { UUID(uuidString: $0.recordID.recordName) } ?? nil
        
        // Retorna um objeto Work
        return Work(id: id, title: title, description: description, image: image, location: location, tag: tag, artistID: artistID)
    }
}
    

