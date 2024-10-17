//
//  CloudKitService.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 17/10/24.
//

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
                    print("Biography: \(artist.biography ?? "No biography")")
                    self.fetchAndPrintWorks(for: artist) // Chama a função para buscar as obras
                }
            case .failure(let error):
                print("Error fetching artists: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchAndPrintWorks(for artist: Artist) {
        modelCloudKit.fetchWorks(for: artist) { result in
            switch result {
            case .success(let works):
                for work in works {
                    print("Work Title: \(String(describing: work.title))")
                    print("Description: \(String(describing: work.description))")
                    print("Tags: \(work.tag.joined(separator: ", "))")
                    
                    print("\n")
                }
            case .failure(let error):
                print("Error fetching works: \(error.localizedDescription)")
            }
        }
    }

}
