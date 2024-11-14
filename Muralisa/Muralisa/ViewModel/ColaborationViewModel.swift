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
    
    var artistList: [(id: String, name: String)] = []
    var artists: [String] = []

    var location: CLLocation?
    var image: UIImage?
    
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
    
    
}
