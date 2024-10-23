//
//  RecommendationService.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 21/10/24.
//

import SwiftUI
import CoreLocation

@Observable
class RecommendationService: ObservableObject {
    var works: [Work] = []
    var workService = WorkService()
    let defaults = UserDefaults.standard
    
    let today = Date()
    var todayWork: Work
    
    init() {
        self.todayWork = Work(id: UUID(),
                              title: "",
                              workDescription: "",
                              image: UIImage(systemName: "photo.badge.exclamationmark")!,
                              location: CLLocation(latitude: 0, longitude: 0),
                              tag: [""],
                              artist: nil)
    }

    //TODO: limit the time interval that works cannot be repeated
    func setupRecommendation() async throws {
        let workResults = try await workService.fetchWorks()
        
        // if there are works that have already been seen
        if let worksExhibited = defaults.value(forKey: "worksExhibited") as? [String] {
            let lastDate = defaults.value(forKey: "lastDateExhibited") as! Date
            
            //if the last date is more than one day apart from today
            if compareDates(today, lastDate) {
   
                todayWork = chooseWork(workResults, worksExhibited)
                let todayWorkUiidString = todayWork.id.uuidString
                
                // add new value to exhibited list
                var worksExhibited = worksExhibited
                worksExhibited.append(todayWorkUiidString)
                defaults.set(worksExhibited, forKey: "worksExhibited")
                
            // if the last date is no more than one day apart from today
            } else {
                let lastWorkUiidString = worksExhibited.last!
                
                //TODO: Buscar obra dado o uiidString
                if let lastWorkObject = self.findWork(by: lastWorkUiidString, in: workResults) {
                    self.todayWork = lastWorkObject
                } else {
                    
                    self.todayWork = chooseWork(workResults, worksExhibited)
                }
            }
            
        //if no work has been seen before
        } else {
            defaults.set(today, forKey: "lastDateExhibited")
            todayWork = workResults.first!
         
            defaults.set([todayWork.id.uuidString], forKey: "worksExhibited")
        }
        
        works = workResults
    }
    
//    func compareDates(_ date1: Date, _ date2: Date) -> Bool {
//        let calendar = Calendar.current
//        let startOfDay1 = calendar.startOfDay(for: date1)
//        let startOfDay2 = calendar.startOfDay(for: date2)
//        
//        let components = calendar.dateComponents([.day], from: startOfDay1, to: startOfDay2)
//        
//        // Returns true if the difference in days is 1 or more
//        if let dayDifference = components.day {
//            return abs(dayDifference) >= 1
//        }
//        
//        return false
//    }
    
    func compareDates(_ date1: Date, _ date2: Date) -> Bool {
        let timeDifference = max(abs(date1.timeIntervalSince(date2)), abs(date2.timeIntervalSince(date1)))
        
        // Retorna true se a diferença for maior que 10 segundos
        return timeDifference > 10
    }
    
    func chooseWork(_ fetchedWorks: [Work], _ lastExhibitedWorks: [String]) -> Work {
        for element in fetchedWorks {
            if !lastExhibitedWorks.contains(element.id.uuidString) {
                return element
            }
        }
        
        return Work(id: UUID(),
                    title: "",
                    workDescription: "",
                    image: UIImage(systemName: "photo.badge.exclamationmark")!,
                    location: CLLocation(latitude: 0, longitude: 0),
                    tag: [""],
                    artist: nil)
    }
    
    func findWork(by uuidString: String, in works: [Work]) -> Work? {
        // Tenta converter a string fornecida em um UUID
        guard let uuid = UUID(uuidString: uuidString) else {
            print("Invalid UUID string")
            return nil
        }
        
        // Busca na lista o objeto Work que tenha o UUID correspondente
        return works.first { $0.id == uuid }
    }

    
}
