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
    
    let id: UUID
    let name: String
    let image: UIImage?
    let biography: String?
    let works: [Work]
    
    // Inicializador
    init(id: UUID, name: String, image: UIImage?, biography: String?, works: [Work]) {
        self.id = id
        self.name = name
        self.image = image
        self.biography = biography
        self.works = works
    }
}

