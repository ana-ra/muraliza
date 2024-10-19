class CloudKitService {
    var modelCloudKit = ModelCloudKit()
    
    init() {
        self.fetchAndPrintArtists()
    }
    
    func fetchAndPrintArtists() {
        modelCloudKit.fetchArtists { result in
            switch result {
            case .success(let artists):
                for artist in artists {
                    print("Artist: \(artist.name)")
                    print("Biography: \(artist.biography)")
                    
                    self.fetchWorks(for: artist)
                }
            case .failure(let error):
                print("Error fetching artists: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWorks(for artist: Artist) {
        modelCloudKit.fetchWorks() { result in
            switch result {
            case .success(let works):
                if works.isEmpty {
                    print("No works found for artist: \(artist.name)")
                } else {
                    for work in works {
                        print("Work Title: \(work.title)")
                        print("Work Description: \(work.description)")
                    }
                }
            case .failure(let error):
                print("Error fetching works: \(error.localizedDescription)")
            }
        }
    }
}
