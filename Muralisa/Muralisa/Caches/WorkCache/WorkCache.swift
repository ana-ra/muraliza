//
//  ImageCache.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 27/10/24.
//

import SwiftUI

class WorkCache {
    static let shared = WorkCache()
    private let cache = NSCache<NSString, Work>()
    private init() {
        cache.countLimit = 100
    }
    
    func getWork(forKey key: String) -> Work? {
        cache.object(forKey: NSString(string: key))
    }
    
    // Key should be the Work.id
    func setWork(_ work: Work, forKey key: String) {
        // Might add animation
        cache.setObject(work, forKey: key as NSString)
    }
}
