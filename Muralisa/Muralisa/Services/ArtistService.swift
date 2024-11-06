import SwiftUI
import CloudKit

class ArtistService {
    var ckService = CloudKitService()
    
    func fetchArtists() async throws -> [Artist] {
        let records: [CKRecord] = try await ckService.fetchRecordsByType(Artist.recordType)
        return records.map { convertRecordToArtist($0) }
    }
    
    func fetchArtistFromReference(_ reference: CKRecord.Reference?) async throws -> Artist {
        guard let reference else {
            throw NSError()
        }
        let record = try await ckService.fetchRecordFromReference(from: reference)
        return convertRecordToArtist(record)
    }
    
    func fetchArtistFromRecordName(from recordName: String) async throws -> Artist {
        let record = try await ckService.fetchRecordFromRecordName(from: recordName)
        return convertRecordToArtist(record)
    }
    
    func convertRecordToArtist(_ record: CKRecord) -> Artist {
        let id = record["Name"] as? String ?? UUID().uuidString
        let name = record["Nickname"] as? String ?? "Unknown Artist"
        let biography = record["Biography"] as? String
        var photo: UIImage? = nil
        if let photoAsset = record["Photo"] as? CKAsset,
           let url = photoAsset.fileURL {
            if let photoData = try? Data(contentsOf: url) {
                photo = UIImage(data: photoData)
            }
        }
        let instagram: String? = record["Instagram"] as? String
        
        // Primeiro, obter a lista de referências de obras
        var worksReferences: [CKRecord.Reference] = []
        if let references = record["Work"] as? [CKRecord.Reference] {
            worksReferences = references
        }
        
        // Depois, converter essas referências para strings (normalmente o recordID)
        let worksReferencesStrings = worksReferences.map { $0.recordID.recordName }
        return Artist(id: id, name: name, image: photo, biography: biography, works: worksReferencesStrings, instagram: instagram)
    }
}
