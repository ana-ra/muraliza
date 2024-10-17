//
//  CloudKitService.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 17/10/24.
//

class CloudKitService {
    var modelCloudKit = ModelCloudKit()
    
    init(){
        self.fetchAndPrintArtists()
    }
    
    func fetchAndPrintArtists() {
        modelCloudKit.fetchArtists { result in
            switch result {
            case .success(let artists):
                for artist in artists {
                    print(artist.name)
                    print(artist.biography)
                }
            case .failure(let error):
                print("Error fetching artists: \(error.localizedDescription)")
            }
        }
    }
}
