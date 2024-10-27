import SwiftUI
import CloudKit

class WorkService {
    var ckService = CloudKitService()
    var artistService = ArtistService()
    
    func fetchWorks() async throws -> [Work] {
        let records = try await ckService.fetchRecordsByType(Work.recordType)
        var works: [Work] = []
        
        for record in records {
            let work = try await convertRecordToWork(record)
            works.append(work)
        }
        
        return works
    }
    
    // TODO: See if this function is really necessary, and if so, see if this is the best place for it
    // Maybe make it async throw, and remove Task block
    func fetchWorksFromArtist(artist: Artist) {
        Task{
            do {
                var listWorks:[Work] = []
                for workReference in artist.works {
                    let work = try await fetchWorkFromRecordName(from: workReference)
                    listWorks.append(work)
                }
                
                for work in listWorks {
                    print("o nome da obras do artista é: \(String(describing: work.title))")
                }
                
            } catch{
                print("Failed to fetch works: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWorkFromRecordName(from recordName: String) async throws -> Work {
        let record = try await ckService.fetchRecordFromRecordName(from: recordName)
        return try await convertRecordToWork(record)
    }
    
    func convertRecordToWork(_ record: CKRecord) async throws -> Work {
        let id = String(record.recordID.recordName)
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
            let artistRecord = try await ckService.fetchRecordFromReference(from: reference)
            artist = artistService.convertRecordToArtist(artistRecord)
        } else {
            print("Obra sem referência de artista: \(title)")
        }
        
        return Work(
            id: id,
            title: title,
            workDescription: description,
            image: image ?? UIImage(systemName: "photo.badge.exclamationmark")!,
            location: location,
            tag: tag,
            artist: artist
        )
    }
}
