//
//  UIImage+ImageCache.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 27/10/24.
//

import SwiftUI
import CloudKit

@Observable
class CachedWorkManager: ObservableObject {
    var currentState: CurrentState?
    let workService = WorkService()
    
    @MainActor
    func load(from recordName: String, cache: WorkCache = .shared) async throws {
        self.currentState = .loading
        // Check if the Work object is already in the cache
        if let cachedWork = WorkCache.shared.getWork(forKey: recordName) {
            self.currentState = .success(work: cachedWork)
            #if DEBUG
            print("Fetching work: \(recordName) from cache...")
            #endif
            return
        }
        
        // Get the work from the record name
        // Add the work to cache
        do {
            let work = try await workService.fetchWorkFromRecordName(from: recordName)
            self.currentState = .success(work: work)
            cache.setWork(work, forKey: recordName)
            print("Memory size in bytes of image \(recordName): \(work.image.memorySizeInBytes)")
            if let jpegData = work.image.jpegData(compressionQuality: 1.0) {
                print("JPEG disk size in bytes: \(jpegData.count)")
            }
            if let pngData = work.image.pngData() {
                print("PNG disk size in bytes: \(pngData.count)")
            }
            #if DEBUG
            print("Caching work: \(recordName)...")
            #endif
        } catch {
            self.currentState = .failed(error: error)
        }

    }
}

extension CachedWorkManager {
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(work: Work)
    }
}

extension CachedWorkManager.CurrentState: Equatable {
    static func == (lhs: CachedWorkManager.CurrentState, rhs: CachedWorkManager.CurrentState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .success(lhsWork), let .success(rhsWork)):
            return lhsWork == rhsWork
        default:
            return false
        }
    }
}

extension UIImage {
    var memorySizeInBytes: Int {
        guard let cgImage = self.cgImage else { return 0 }
        let bytesPerPixel = 4 // Assuming RGBA, which is common
        return cgImage.width * cgImage.height * bytesPerPixel
    }
}
