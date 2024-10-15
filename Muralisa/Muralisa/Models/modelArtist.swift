//
//  modelArtist.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//
import Foundation
import SwiftUI
import CloudKit


class Artist {
    static let recordType: String = "Artist"
    private let id: CKRecord.ID
    let name: String
    let image: Image?
    let work: [Work]
    let biography: String?
    
    
    init(id: CKRecord.ID, name: String, image: Image?, works: [Work], biography: String?) {
        self.id = id
        self.name = name
        self.image = image
        self.work = works
        self.biography = biography
    }
    
}
