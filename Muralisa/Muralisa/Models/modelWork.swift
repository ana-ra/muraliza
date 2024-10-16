//
//  modelWork.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//

import Foundation
import CloudKit

class Work {
    static let recordType: String = "Work"
    
    let id: UUID
    let title: String
    let description: String
    let image: CKAsset?
    let location: CLLocation?
    let style: String
    let artistID: UUID?
    
    // Inicializador
    init(id: UUID, title: String, description: String, image: CKAsset?, location: CLLocation?, style: String, artistID: UUID?) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.location = location
        self.style = style
        self.artistID = artistID
    }
}


