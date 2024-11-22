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
        let fetchedRecords = try await ckService.fetchRecordsByType(Work.recordType, predicate: predicate)
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
    
    func fetchListOfWorksFromListOfIds(IDs: [String]?) async throws -> [Work] {
        print(IDs ?? "there is no favorites")
        guard let IDs else {return []}
        if IDs.isEmpty {return []}
        
        var works: [Work] = []
        for id in IDs{
            let work = try await fetchWorkFromRecordName(from: id)
            works.append(work)
        }
        
        return works
    }
    
    func convertRecordsToWorks(_ records: [CKRecord]) async throws -> [Work] {
        var works: [Work] = []
        for record in records {
            let work = try await self.convertRecordToWork(record)
            works.append(work)
        }
        return works
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
        
        // Handle image loading asynchronously
        var imageThumb: UIImage? = nil
        if let imageAsset = record["Image_thumbnail"] as? CKAsset,
           let url = imageAsset.fileURL {
            let imageData = try await Task.detached {
                return try Data(contentsOf: url)
            }.value
            
            imageThumb = UIImage(data: imageData)
        }
//
        let location = record["Location"] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        
        // Fetch artist record, if it exists
        let artistReference = record["Artist"] as? [CKRecord.Reference]
        
        return Work(
            id: id,
            title: title,
            workDescription: description,
            image: image ?? UIImage(systemName: "photo.badge.exclamationmark")!,
            imageThumb: imageThumb ?? UIImage(systemName: "photo.badge.exclamationmark")!,
            location: location,
            tag: tag,
            artist: artistReference,
            creationDate: creationDate,
            status: status
            
        )
    }
    
    // Function to update all Artwork records with an Image_thumbnail field
    func updateArtworkRecordsWithThumbnail() async throws {
        // Fetch all Artwork records
        let artworkRecords = try await ckService.fetchRecordsByType(Work.recordType)
        var updatedRecords: [CKRecord] = []
        
        for record in artworkRecords {
            // Check if the Image field exists
            guard let asset = record["Image"] as? CKAsset,
                  let fileURL = asset.fileURL,
                  let imageData = try? Data(contentsOf: fileURL),
                  let image = UIImage(data: imageData) else {
                print("No valid Image field for record: \(record.recordID.recordName)")
                continue
            }
            
            // Compress the image to create a thumbnail
            let resizedImage = image.aspectFittedToHeight(200)
            resizedImage.jpegData(compressionQuality: 0.2) // Add this line
            let thumbnail = resizedImage
            
            guard let thumbnailData = thumbnail.pngData(),
                  let tempURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("thumbnail_\(record.recordID.recordName).png") else {
                print("Failed to create thumbnail for record: \(record.recordID.recordName)")
                continue
            }
            
            // Write the thumbnail data to a temporary file
            do {
                try thumbnailData.write(to: tempURL)
                let thumbnailAsset = CKAsset(fileURL: tempURL)
                record["Image_thumbnail"] = thumbnailAsset
                updatedRecords.append(record)
            } catch {
                print("Error writing thumbnail to file for record: \(record.recordID.recordName), \(error.localizedDescription)")
            }
        }
        
        // Save all updated records back to CloudKit
        try await ckService.modifyRecords(updatedRecords)
        print("Successfully updated \(updatedRecords.count) records with Image_thumbnail.")
    }

    // Function to post a new Work type to CloudKit
    func saveWork(
        title: String,
        workDescription: String,
        tag: [String],
        image: UIImage?,
        imageThumb: UIImage?,
        location: CLLocation,
        artistReference: [CKRecord.Reference]?
    ) async throws -> CKRecord? {
        // Create a new CKRecord for Work
        let workRecord = CKRecord(recordType: Work.recordType)
        workRecord["Title"] = title
        workRecord["Description"] = workDescription
        workRecord["Tag"] = tag
        workRecord["Location"] = location
        workRecord["Artist"] = artistReference
        workRecord["Status"] = 2
      
        // Handle optional image
        if let image = image,
           let tempURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("imagePlaceholder.png"),
           let data = image.pngData() {
            do {
                try data.write(to: tempURL)
                let asset = CKAsset(fileURL: tempURL)
                workRecord["Image"] = asset
            } catch {
                print("Error writing image to cache: \(error.localizedDescription)")
            }
        } else {
            print("Error: invalid image")
        }

        // Handle optional imageThumb
        if let imageThumb = imageThumb,
           let tempThumbURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("imageThumbPlaceholder.png"),
           let thumbData = imageThumb.pngData() {
            do {
                try thumbData.write(to: tempThumbURL)
                let thumbAsset = CKAsset(fileURL: tempThumbURL)
                workRecord["Image_thumbnail"] = thumbAsset
            } catch {
                print("Error writing imageThumb to cache: \(error.localizedDescription)")
            }
        } else {
            print("Error: invalid imageThumb")
        }

        // Save the record to CloudKit
        return try await ckService.saveRecord(workRecord)
    }
}
