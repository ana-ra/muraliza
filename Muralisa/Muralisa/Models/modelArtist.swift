//
//  modelArtist.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//
import Foundation
import UIKit

class Artist {
    static let recordType: String = "Artist"
    
    let id: String
    let name: String
    let image: UIImage?
    let biography: String?
    let works: [String]
    
    // Inicializador
    init(id: String, name: String, image: UIImage?, biography: String?, works: [String]) {
        self.id = id
        self.name = name
        self.image = image
        self.biography = biography
        self.works = works
    }
}

