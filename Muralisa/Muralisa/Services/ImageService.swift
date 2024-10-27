//
//  ImageService.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 26/10/24.
//

import Foundation
import CloudKit

// Service to only fetch the records of the images, but not convert
// Discovered the latency bottleneck is in the conversion of record to work,
// Specifically considering downloading all images.

@Observable
class ImageService: ObservableObject {
    var works: [CKRecord] = []
    var service = CloudKitService()
    
    // Only fetches the records, does not convert
    func populate() async throws {
        works = try await service.fetchRecordsByType(Work.recordType)
    }
}
