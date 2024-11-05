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
    var nearbyWorks: [Work] = []
    
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
    }
    
    func setupRecommendationByDistance(userPosition: CLLocation?) async throws {
        let resultRecords = service.fetchRecordsByDistance(userPosition: userPosition)
        var resultWorks: [Work] = []
        
        for record in resultRecords {
            let work = try await workService.convertRecordToWork(record)
            resultWorks.append(work)
        }
        
        self.nearbyWorks = resultWorks
    }

    private func addNewRandomWorkToExhibitedList(chooseRandomWorkFrom: [CKRecord], exhibitedList: [String]) async throws {
        let todayWorkRecord = chooseRandomWorkFrom.first!
        let todayWorkID = todayWorkRecord.recordID.recordName
        
        var updatedWorksExhibited = exhibitedList
        updatedWorksExhibited.append(todayWorkID)
        defaults.set(updatedWorksExhibited, forKey: "worksExhibited")
        defaults.set(today, forKey: "lastDateExhibited")
        
        todayWork = try await workService.convertRecordToWork(todayWorkRecord)
        print("Today's work ID: \(todayWorkID)")
    }
    
    // Returns true if there's a 1 day or more difference between last date exhibited
    private func compareDates(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDay1 = calendar.startOfDay(for: date1)
        let startOfDay2 = calendar.startOfDay(for: date2)
        
        let components = calendar.dateComponents([.day], from: startOfDay1, to: startOfDay2)
        
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
    
    private func addIDToExhibitedList(_ id: String) {
        var worksExhibited = defaults.value(forKey: "worksExhibited") as? [String] ?? []
        worksExhibited.append(id)
        defaults.set(worksExhibited, forKey: "worksExhibited")
    }
    
    func setupRecommendation() async throws {
        let lastDate = defaults.value(forKey: "lastDateExhibited") as? Date
        let worksExhibited = defaults.value(forKey: "worksExhibited") as? [String] ?? []
        
        if let lastDate = lastDate, let lastWork = worksExhibited.last, compareDates(lastDate, today) {
            todayWork = try await workService.fetchWorkFromRecordName(from: lastWork)
            return
        }
        
        // Usage in an async context:
        if let fetchedRecord = await fetchSingleNonExhibitedWork(excluding: worksExhibited) {
            print("Funcionou, fetched record: \(fetchedRecord)")
            todayWork = try await workService.fetchWorkFromRecordName(from: fetchedRecord.recordID.recordName)
        } else {
            print("No record found or error fetching")
        }
    }
    
    private func fetchSingleNonExhibitedWork(excluding excludedWorks: [String]) async -> CKRecord? {
        await withCheckedContinuation { continuation in
            service.fetchSingleWorkExcluding(recordNamesToExclude: excludedWorks) { [weak self] record in
                guard let self = self, let record = record else {
                    print("No record found or error fetching")
                    continuation.resume(returning: nil)
                    return
                }

                // Update the exhibited works and last date
                var worksExhibited = excludedWorks
                worksExhibited.append(record.recordID.recordName)
                self.defaults.set(worksExhibited, forKey: "worksExhibited")
                self.defaults.set(self.today, forKey: "lastDateExhibited")

                continuation.resume(returning: record)
            }
        }
    }
}
