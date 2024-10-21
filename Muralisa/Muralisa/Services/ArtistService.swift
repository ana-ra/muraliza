import SwiftUI

class ArtistService {
    
    var modelCloudKit = ModelCloudKit()

    func fetchArtistsAndPrint() {
        Task {
            do {
                let artists = try await self.modelCloudKit.fetchArtists()
                                
                print("Fetched \(artists.count) artists:")
                for artist in artists {
                    print(artist.name)                    
                }
            } catch {
                print("Failed to fetch artists: \(error.localizedDescription)")
            }
        }
    }
}
