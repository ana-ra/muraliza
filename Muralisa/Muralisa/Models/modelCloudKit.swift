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
    
    // Função para buscar todas as obras relacionadas a um artista
    func fetchWorks(for artist: Artist, completion: @escaping (Result<[Work], Error>) -> Void) {
        // Cria a referência para o artista
        let artistRecordID = CKRecord.ID(recordName: artist.id.uuidString)
        let artistReference = CKRecord.Reference(recordID: artistRecordID, action: .none)
        
        // Cria um predicado para buscar as obras que tenham a referência ao artista
        let predicate = NSPredicate(format: "Artist == %@", artistReference)
        let query = CKQuery(recordType: Work.recordType, predicate: predicate)
        
        // Executa a consulta no banco de dados público
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
            
            // Retorna os resultados na thread principal
            DispatchQueue.main.async {
                completion(.success(works))
            }
        }
    }
    
    // Função para converter CKRecord para Work com as referências
    func convertRecordToWork(_ record: CKRecord) -> Work {
        let id = UUID() // Cria um UUID para a obra
        let title = record["Title"] as? String ?? "Unknown Title"
        let description = record["Description"] as? String ?? "No Description"
        let tag = record["Tag"] as? [String] ?? ["No tags"]

        // Recebe imagem como CKAsset, converte para Data e depois converte para UIImage
        var image: UIImage? = nil
        if let imageAsset = record["Image"] as? CKAsset,
           let url = imageAsset.fileURL {
            if let imageData = try? Data(contentsOf: url) {
                image = UIImage(data: imageData)
            } else {
                image = UIImage(systemName: "custom.photo.slash")
            }
        }
        
        // Pega a localização como CLLocation
        let location = record["Location"] as? CLLocation
        
        // Pega a referência do artista
        let artistReference = record["Artist"] as? CKRecord.Reference

        // Mapeia o recordName para UUID se o artista existir
        let artistID = artistReference?.recordID.recordName

        // Retorna o objeto Work com a referência ao artista
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

    

