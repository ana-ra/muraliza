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
    
    let id: CKRecord.ID
    let title: String
    let description: String
    let image: CKAsset?
    let location: CLLocation?
    let style: String
    let artistReference: CKRecord.Reference?
    
    init(record: CKRecord) {
        self.id = record.recordID
        self.title = record["Title"] as? String ?? "Unknown Title"
        self.description = record["Description"] as? String ?? "No Description"
        self.image = record["Image"] as? CKAsset
        self.location = record["Location"] as? CLLocation
        self.style = record["Style"] as? String ?? "Unknown Style"
        self.artistReference = record["Artist"] as? CKRecord.Reference
    }
    
    init(id: CKRecord.ID, title: String, description: String, image: CKAsset?, location: CLLocation?, style: String, artistReference: CKRecord.Reference?) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.location = location
        self.style = style
        self.artistReference = artistReference
    }
}

