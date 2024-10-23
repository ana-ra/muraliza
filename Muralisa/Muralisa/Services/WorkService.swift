import SwiftUI

class WorkService {
    
    var ckService = CloudKitService()
    
    func fetchWorks() async throws ->  [Work] {
        var resultWorks: [Work] = []
                let works = try await self.ckService.fetchWorks()
                resultWorks = works
                return resultWorks
        
    }
    
    func fetchWorksFromArtist(artist: Artist) {
        Task{
            do {
                var listWorks:[Work] = []
                for workReference in artist.works {
                    let work = try await self.ckService.fetchWorkFromReference(from: workReference)
                    listWorks.append(work)
                }
                
                for work in listWorks {
                    print("o nome da obras do artista é: \(String(describing: work.title))")
                }
                
            } catch{
                print("Failed to fetch works: \(error.localizedDescription)")
            }
        }
    }

}
