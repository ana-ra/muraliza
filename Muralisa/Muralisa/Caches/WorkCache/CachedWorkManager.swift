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
