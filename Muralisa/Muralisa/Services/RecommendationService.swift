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
        self.todayWork = Work(id: UUID().uuidString,
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
                self.addNewRandomWorkToExhibitedList(chooseRandomWorkFrom: workResults, exhibitedList: worksExhibited)
                
            // if the last date is no more than one day apart from today
            } else {
                let lastWorkUiidString = worksExhibited.last!
                
                // tries to access the last element of the saved list
                if let lastWorkObject = self.findWork(by: lastWorkUiidString, in: workResults) {
                    self.todayWork = lastWorkObject
                    
                //if can't access it, search for new art and add it to the saved list
                } else {
                    self.addNewRandomWorkToExhibitedList(chooseRandomWorkFrom: workResults, exhibitedList: worksExhibited)
                }
            }
            
        //if no work has been seen before
        } else {
            todayWork = workResults.first!
         
            defaults.set([todayWork.id], forKey: "worksExhibited")
            defaults.set(today, forKey: "lastDateExhibited")
        }
        
        works = workResults
    }
    
    private func addNewRandomWorkToExhibitedList(chooseRandomWorkFrom: [Work], exhibitedList: [String]){
        todayWork = chooseWork(chooseRandomWorkFrom, exhibitedList)
        let todayWorkID = todayWork.id
        
        // add new value to exhibited list
        var worksExhibited = exhibitedList
        worksExhibited.append(todayWorkID)
        
        defaults.set(worksExhibited, forKey: "worksExhibited")
        defaults.set(today, forKey: "lastDateExhibited")
    }
    
    private func compareDates(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDay1 = calendar.startOfDay(for: date1)
        let startOfDay2 = calendar.startOfDay(for: date2)
        
        let components = calendar.dateComponents([.day], from: startOfDay1, to: startOfDay2)
        
        // Returns true if the difference in days is 1 or more
        if let dayDifference = components.day {
            return abs(dayDifference) >= 1
        }
        
        return false
    }
    
    private func chooseWork(_ fetchedWorks: [Work], _ lastExhibitedWorks: [String]) -> Work {
        for element in fetchedWorks {
            if !lastExhibitedWorks.contains(element.id) {
                return element
            }
        }
        
        return Work(id: UUID().uuidString,
                    title: "",
                    workDescription: "",
                    image: UIImage(systemName: "photo.badge.exclamationmark")!,
                    location: CLLocation(latitude: 0, longitude: 0),
                    tag: [""],
                    artist: nil)
    }
    
    private func findWork(by uuidString: String, in works: [Work]) -> Work? {
        return works.first { $0.id == uuidString }
    }

    
}
