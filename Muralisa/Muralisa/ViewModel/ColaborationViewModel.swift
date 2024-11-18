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

@Observable
class ColaborationViewModel: ObservableObject {
    var artistServivce = ArtistService()
    
    var artistList: [Artist] = []
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
        //  var artistsIDList: [String] = []
        artistList = try await artistServivce.fetchArtists()
        
        for artist in artistList {
            artistsNameList.append(artist.name)
            //   artistsIDList.append(artist.id)
        }
        
        self.artists = artistsNameList
        //  self.artistsID = artistsIDList
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
}
