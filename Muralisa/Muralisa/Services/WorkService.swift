import SwiftUI
import CloudKit

@Observable
class WorkService: ObservableObject {
    var ckService = CloudKitService()
    var artistService = ArtistService()
    var pendingWorkRecords: [CKRecord] = []
    
    func fetchWorks(onWorkConverted: @escaping (Work) -> Void) async throws -> [Work] {
        let records = try await ckService.fetchRecordsByType(Work.recordType)
        var works: [Work] = []
        
        await withTaskGroup(of: Work?.self) { group in
            for record in records {
                group.addTask {
                    do {
                        let work = try await self.convertRecordToWork(record)
                        DispatchQueue.main.async {
                            onWorkConverted(work)
                        }
                        return work
                    } catch {
                        print("Error converting record \(record.recordID.recordName): \(error)")
                        return nil
                    }
                }
            }
            
            for await work in group {
                if let work = work {
                    works.append(work)
                }
            }
        }
        return works
    }
    
    func fetchPendingWorkRecords() async throws {
        let predicate = NSPredicate(format: "Status == 2")
        let fetchedRecords = try await ckService.fetchRecordsByType(Work.recordType, withPredicate: predicate)
        pendingWorkRecords = fetchedRecords
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
    
    func updateStatus(of work: Work, to status: Int) {
        work.status = status
        ckService.updateRecordField(recordName: work.id, newValue: status, forKey: "Status")
    }
    
    func fetchWorkFromRecordName(from recordName: String) async throws -> Work {
        let record = try await ckService.fetchRecordFromRecordName(from: recordName)
        return try await convertRecordToWork(record)
    }
    
    func convertRecordsToWorks(_ records: [CKRecord]) async throws -> [Work] {
        await withTaskGroup(of: Work?.self) { group in
            var works: [Work] = []
            
            for record in records {
                group.addTask {
                    do {
                        return try await self.convertRecordToWork(record)
                    } catch {
                        print("Error converting record \(record.recordID.recordName): \(error)")
                        return nil
                    }
                }
            }
            
            for await work in group {
                if let work = work {
                    works.append(work)
                }
            }
            
            return works
        }
    }

    func convertRecordToWork(_ record: CKRecord) async throws -> Work {
        let id = String(record.recordID.recordName)
        let title = record["Title"] as? String ?? "Unknown Title"
        let description = record["Description"] as? String ?? "No Description"
        let tag = record["Tag"] as? [String] ?? ["No tags"]
        let creationDate = record.creationDate ?? Date()
        let status = record["Status"] as? Int ?? 1
        
        // Handle image loading asynchronously
        var image: UIImage? = nil
        if let imageAsset = record["Image"] as? CKAsset,
           let url = imageAsset.fileURL {
            let imageData = try await Task.detached {
                return try Data(contentsOf: url)
            }.value
            
            image = UIImage(data: imageData)
        }
//        
        let location = record["Location"] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)

        // Fetch artist record, if it exists
        let artistReference = record["Artist"] as? [CKRecord.Reference]
        print("data de criação da função \(creationDate)")
        print("data de agora \(Date())")

        return Work(
            id: id,
            title: title,
            workDescription: description,
            image: image ?? UIImage(systemName: "photo.badge.exclamationmark")!,
            location: location,
            tag: tag,
            artist: artistReference,
            creationDate: creationDate,
            status: status
            
        )
    }
}
