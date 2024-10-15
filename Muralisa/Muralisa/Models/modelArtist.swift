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
    
    let id: CKRecord.ID
    let name: String
    let image: CKAsset?
    let biography: String?
    var works: [Work] = []
    
    init(record: CKRecord) {
        self.id = record.recordID
        self.name = record["Name"] as? String ?? "Unknown Artist"
        self.biography = record["Biography"] as? String
        self.image = record["Photo"] as? CKAsset
    }
    
    init(id: CKRecord.ID, name: String, image: CKAsset?, biography: String?) {
        self.id = id
        self.name = name
        self.image = image
        self.biography = biography
    }
}

