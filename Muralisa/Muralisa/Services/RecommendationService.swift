//
//  RecommendationService.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 21/10/24.
//

import SwiftUI
import CoreLocation
import CloudKit

@Observable
class RecommendationService: ObservableObject {
    var works: [CKRecord] = []
    var workService = WorkService()
    var service = CloudKitService()
    let defaults = UserDefaults.standard
    
    let today = Date()
    var todayWork: Work
    var nearbyWorks: [Work]
    
    init() {
        self.todayWork = Work(id: UUID().uuidString,
                              title: "",
                              workDescription: "",
                              image: UIImage(systemName: "photo.badge.exclamationmark")!,
                              location: CLLocation(latitude: 0, longitude: 0),
                              tag: [""],
                              artist: nil,
                              creationDate: Date(),
                              status: 1)
        
        self.nearbyWorks = [Work(id: UUID().uuidString,
                              title: "",
                              workDescription: "",
                              image: UIImage(systemName: "photo.badge.exclamationmark")!,
                              location: CLLocation(latitude: 0, longitude: 0),
                              tag: [""],
                              artist: nil,
                              creationDate: Date(),
                              status: 1)]
    }
    
    func setupRecommendationByDistance() async throws {
        let worksByDistanceRecords = try await service.fetchRecordsByDistance( distanceInKilometers: Constants().distanceToCloseArtworks)
        nearbyWorks = try await workService.convertRecordsToWorks(worksByDistanceRecords)
    }
    
    func setupRecommendation2() async throws {
        // Retrieve last exhibited data from UserDefaults
        let lastDate = defaults.value(forKey: "lastDateExhibited") as? Date
        let worksExhibited = defaults.value(forKey: "worksExhibited") as? [String] ?? []
        
        // Check if its been a day since the last exhibition, if not, just fetch today's work
        if let lastDate = lastDate, let lastWork = worksExhibited.last, compareDates(lastDate, today) {
            // Will throw if this doesnt work, no need to check
            todayWork = try await workService.fetchWorkFromRecordName(from: lastWork)
            return
        }
        
        // If work data is missing or outdated, fetch new works
        let workResults = try await service.fetchRecordsByType(Work.recordType)
        
        // Check if there are already exhibited works
        if !worksExhibited.isEmpty {
            // Add new work if today's recommendation was already shown
            try await addNewRandomWorkToExhibitedList(chooseRandomWorkFrom: workResults, exhibitedList: worksExhibited)
        } else {
            // First time fetching works; initialize recommendation
            todayWork = try await workService.convertRecordToWork(workResults.first!)
            defaults.set([todayWork.id], forKey: "worksExhibited")
            defaults.set(today, forKey: "lastDateExhibited")
        }
        
        works = workResults
    }

    //TODO: limit the time interval that works cannot be repeated
//    func setupRecommendation() async throws {
//        let workResults = try await workService.fetchWorks { work in
//            self.works.append(work)
//        }
//        
//        // if there are works that have already been seen
//        if let worksExhibited = defaults.value(forKey: "worksExhibited") as? [String] {
//            let lastDate = defaults.value(forKey: "lastDateExhibited") as! Date
//            
//            //if the last date is more than one day apart from today
//            if compareDates(today, lastDate) {
//                self.addNewRandomWorkToExhibitedList(chooseRandomWorkFrom: workResults, exhibitedList: worksExhibited)
//                
//            // if the last date is no more than one day apart from today
//            } else {
//                let lastWorkUiidString = worksExhibited.last!
//                
//                // tries to access the last element of the saved list
//                if let lastWorkObject = self.findWork(by: lastWorkUiidString, in: workResults) {
//                    self.todayWork = lastWorkObject
//                    
//                //if can't access it, search for new art and add it to the saved list
//                } else {
//                    self.addNewRandomWorkToExhibitedList(chooseRandomWorkFrom: workResults, exhibitedList: worksExhibited)
//                }
//            }
//            
//        //if no work has been seen before
//        } else {
//            todayWork = workResults.first!
//         
//            defaults.set([todayWork.id], forKey: "worksExhibited")
//            defaults.set(today, forKey: "lastDateExhibited")
//        }
//        
//        works = workResults
//    }
    
    private func addNewRandomWorkToExhibitedList(chooseRandomWorkFrom: [CKRecord], exhibitedList: [String]) async throws {
        let todayWorkRecord = chooseWork(chooseRandomWorkFrom, exhibitedList)
        let todayWorkID = todayWorkRecord.recordID.recordName
        
        // add new value to exhibited list
        var worksExhibited = exhibitedList
        worksExhibited.append(todayWorkID)
        
        defaults.set(worksExhibited, forKey: "worksExhibited")
        defaults.set(today, forKey: "lastDateExhibited")
        
        todayWork = try await workService.convertRecordToWork(todayWorkRecord)
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
    
    private func chooseWork(_ fetchedWorks: [CKRecord], _ lastExhibitedWorks: [String]) -> CKRecord {
        for element in fetchedWorks {
            if !lastExhibitedWorks.contains(element.recordID.recordName) {
                return element
            }
        }
        
        return CKRecord(recordType: Work.recordType)
    }
    
    private func findWork(by uuidString: String, in works: [Work]) -> Work? {
        return works.first { $0.id == uuidString }
    }

    
}
