//
//  modelArtist.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//
import Foundation
import CloudKit
import SwiftUI

class Artist {
    static let recordType: String = "Artist"
    
    let id: UUID  // Identificador agora é UUID
    let name: String
    let image: CKAsset?
    let biography: String?
    
    // Inicializador
    init(id: UUID, name: String, image: CKAsset?, biography: String?) {
        self.id = id
        self.name = name
        self.image = image
        self.biography = biography
    }
}

