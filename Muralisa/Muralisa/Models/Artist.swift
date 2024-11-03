//
//  modelArtist.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//
import Foundation
import UIKit

class Artist: NSObject {
    static let recordType: String = "Artist"
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
    
    let id: String
    let name: String
    let image: UIImage?
    let biography: String?
    let works: [String]
    let instagram: String?
    
    // Inicializador
    init(id: String, name: String, image: UIImage?, biography: String?, works: [String], instagram: String?) {
        self.id = id
        self.name = name
        self.image = image
        self.biography = biography
        self.works = works
        self.instagram = instagram
    }
}

