//
//  TagViewModel.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 20/11/24.
//

import Foundation
import Observation

@Observable
class TagViewModel {
    var worksByTag: [Work] = []
    
    var workService = WorkService()
    var service = CloudKitService()

    func getWorksForTag(tag: String) async throws {
        worksByTag.removeAll()
        let worksByTagsRecords = try await service.fetchRecordByTags([tag], except: UUID().uuidString)
        worksByTag = try await workService.convertRecordsToWorks(worksByTagsRecords)
        print(worksByTag)
    }
}
