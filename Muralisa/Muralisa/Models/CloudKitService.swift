import SwiftUI

class CloudKitService {
    
    var modelCloudKit = ModelCloudKit()
    var artist: [Artist] = [Artist(id: UUID(),
                                   name: "Yago",
                                   image: nil,
                                   biography: "Aham",
                                   works: ["5200CDC3-2A64-4AC5-821A-4C3EE514087C"])]
    
    init() {
        self.fetchArtistsAndPrint()
        self.fetchWorksAndPrint()
        self.fetchWorksFromArtist(artist: artist[0] )
    }
    
    func fetchArtistsAndPrint() {
        Task {
            do {
                let artists = try await self.modelCloudKit.fetchArtists()
                                
                print("Fetched \(artists.count) artists:")
                for artist in artists {
                    print(artist.name)
                    print("a lista de obras é \(artist.works)")
                    self.artist.append(artist)
                    
                }
            } catch {
                print("Failed to fetch artists: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWorksAndPrint() {
        Task {
            do {
                let works = try await self.modelCloudKit.fetchWorks()
                print("Fetched \(works.count) Works:")
                for work in works {
                    print(work.title)
                }
            } catch {
                print("Failed to fetch works: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWorksFromArtist(artist: Artist) {
        Task{
            do {
                var listWorks:[Work] = []
                for workReference in artist.works {
                    let work = try await self.modelCloudKit.fetchWorkFromReference(from: workReference)
                    listWorks.append(work)
                }
                
                for work in listWorks {
                    print("o nome da obras do artista é: \(work.title)")
                }
                
            } catch{
                print("Failed to fetch works: \(error.localizedDescription)")
            }
        }
    }
        
        
        
}
