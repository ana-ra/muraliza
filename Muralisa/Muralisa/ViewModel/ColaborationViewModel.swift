//
//  ColaborationViewModel.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 04/11/24.
//

import Foundation
import SwiftUI
import CloudKit
import CoreLocation
import SwiftData

@Observable
class ColaborationViewModel: ObservableObject {
    var artistServivce = ArtistService()
    var workService = WorkService()
    var ckService = CloudKitService()
    var swiftDataService = SwiftDataService()
    
    var artistList: [(id: String, name: String)] = []
    var artists: [String] = []
    
    var location: CLLocation?
    var image: UIImage?
    var imageThumb: UIImage?
    var compressedImageData: Data?
    
    var artist: String = ""
    var title: String = ""
    var description: String = ""
    
    var artistsID: [CKRecord.Reference] = []
    
    func fetchArtists() async throws {
        
        var artistsNameList: [String] = []
        artistList = try await artistServivce.fetchArtistNamesAndIDs()
        
        for artist in artistList {
            artistsNameList.append(artist.name)
        }
        
        self.artists = artistsNameList
        print(artistList)
    }
    
    func getArtistID(artistName: [String]) {
        artistsID.removeAll()
        for artist in artistList {
            if artistName.contains(artist.name) {
                
                let recordId = CKRecord.ID(recordName: artist.id)
                let record = CKRecord.Reference(recordID: recordId, action: .none)
                
                artistsID.append(record)
                
            }
        }
    }
    
    func compressImage() {
        if let image {
            let resizedImage = image.aspectFittedToHeight(200)
            resizedImage.jpegData(compressionQuality: 0.2) // Add this line
            self.imageThumb = resizedImage
        } else {
            print("image is nil")
        }
    }
    
    func getRecentlyAddedWorks(IDs: [String]) async throws -> [(String, Int)] {
        var recentlyAddedWorks: [(String, Int)] = []
        
        let recordIDs = IDs.map {CKRecord.ID(recordName: $0)}
        
        let records = try await ckService.fetchRecordsByIDsAndDesiredKeys(by: recordIDs, desiredKeys: ["Title", "Status"])
        let works = try await workService.convertRecordsToWorks(records)
        
        for work in works {
            recentlyAddedWorks.append((work.title ?? "", work.status))
            print(work.title ?? "")
            print(work.status)
        }
        recentlyAddedWorks.reverse()
        
        return recentlyAddedWorks
    }
}
