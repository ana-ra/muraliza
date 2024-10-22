import SwiftUI

class WorkService {
    
    var ckService = CloudKitService()
    
    func fetchWorks() -> [Work] {
        var resultWorks: [Work] = []
        Task {
            do {
                let works = try await self.ckService.fetchWorks()
                resultWorks = works
            } catch {
                print("Failed to fetch works: \(error.localizedDescription)")
            }
        }
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
                    print("o nome da obras do artista é: \(work.title)")
                }
                
            } catch{
                print("Failed to fetch works: \(error.localizedDescription)")
            }
        }
    }

}
