//
//  ArtistCache.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 27/10/24.
//
import SwiftUI

class ArtistCache {
    static let shared = ArtistCache()
    let cache = NSCache<NSString, Artist>()
    private var itemCount = 0
    private init() {}
    
    func getArtist(forKey key: String) -> Artist? {
        cache.object(forKey: NSString(string: key))
    }
    
    // Key should be the Work.id
    func setArtist(_ artist: Artist, forKey key: String) {
        // Might add animation
        cache.setObject(artist, forKey: key as NSString)
        itemCount += 1
    }
    
    func count() -> Int {
        itemCount
    }
}
