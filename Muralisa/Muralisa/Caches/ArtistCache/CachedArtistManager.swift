//
//  CachedArtistManager.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 27/10/24.
//

import SwiftUI
import CloudKit

@Observable
class CachedArtistManager: ObservableObject {
    var currentState: CurrentState?
    let artistService = ArtistService()
    
    @MainActor
    func load(from recordName: String?, cache: ArtistCache = .shared) async throws {
        self.currentState = .loading
        
        if let recordName {
            // Check if the Work object is already in the cache
            if let cachedArtist = ArtistCache.shared.getArtist(forKey: recordName) {
                self.currentState = .success(artist: cachedArtist)
                #if DEBUG
                print("Fetching artist: \(recordName) from cache...")
                #endif
                return
            }
            
            // Get the work from the record name
            // Add the work to cache
            do {
                let artist = try await artistService.fetchArtistFromRecordName(from: recordName)
                self.currentState = .success(artist: artist)
                cache.setArtist(artist, forKey: recordName)
                #if DEBUG
                print("Caching artist: \(recordName)...")
                #endif
            } catch {
                self.currentState = .failed(error: error)
            }
        } else {
            self.currentState = .unknown
            #if DEBUG
            print("Artist is unknown")
            #endif
        }
    }
}

extension CachedArtistManager {
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(artist: Artist)
        case unknown
    }
}

extension CachedArtistManager.CurrentState: Equatable {
    static func == (lhs: CachedArtistManager.CurrentState, rhs: CachedArtistManager.CurrentState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .success(lhsWork), let .success(rhsWork)):
            return lhsWork == rhsWork
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
