//
//  ColaborationViewModel.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 04/11/24.
//

import Foundation
import SwiftUI

@Observable
class ColaborationViewModel: ObservableObject {
    var artistServivce = ArtistService()
    
    var artists: [String] = []
    
    
    func fetchArtists() async throws {
        
        var artistsNameList: [String] = []
        let artistsDB = try await artistServivce.fetchArtists()
        
        for artist in artistsDB {
            artistsNameList.append(artist.name)
        }
        
        self.artists = artistsNameList
    }
}
