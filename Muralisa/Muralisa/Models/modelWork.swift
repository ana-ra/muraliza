//
//  modelWork.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//

import Foundation
import CoreLocation
import UIKit

class Work {
    static let recordType: String = "Work"
    
    let id: UUID
    let title: String?
    let description: String?
    let image: UIImage
    let location: CLLocation
    let tag: [String]
    let artistID: UUID?
    
    // Inicializador
    init(id: UUID, title: String?, description: String?, image: UIImage, location: CLLocation, tag: [String], artistID: UUID?) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.location = location
        self.tag = tag
        self.artistID = artistID
    }
}


