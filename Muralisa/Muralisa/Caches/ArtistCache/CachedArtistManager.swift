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
    func load(from references: [CKRecord.Reference]?, cache: ArtistCache = .shared) async throws {
        self.currentState = .loading
        var artists: [Artist] = []
        
        if let references, !references.isEmpty {
            // Checks every reference to see if it's already in the cache
            for reference in references {
                let recordName = reference.recordID.recordName
                if let cachedArtist = ArtistCache.shared.getArtist(forKey: recordName) {
                    artists.append(cachedArtist)
                    #if DEBUG
                    print("Fetching artist: \(recordName) from cache...")
                    #endif
                } else {
                    // Get the artist from the record name
                    // Add the work to cache
                    do {
                        let artist = try await artistService.fetchArtistFromRecordName(from: recordName)
                        cache.setArtist(artist, forKey: recordName)
                        artists.append(artist)
                        #if DEBUG
                        print("Caching artist: \(recordName)...")
                        #endif
                    } catch {
                        self.currentState = .failed(error: error)
                        return
                    }
                }
            }
            self.currentState = .success(artists: artists)
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
        case success(artists: [Artist])
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
