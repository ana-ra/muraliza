class CloudKitService {
    var modelCloudKit = ModelCloudKit()
    init() {
        self.fetchArtistsAndPrint()
        self.fetchWorksAndPrint()
    }
    func fetchArtistsAndPrint() {
        Task {
            do {
                let artists = try await self.modelCloudKit.fetchArtists()
                print("Fetched \(artists.count) artists:")
                for artist in artists {
                    print(artist.name)
                    print("a lista de obras é \(artist.works)")
                    
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
}
