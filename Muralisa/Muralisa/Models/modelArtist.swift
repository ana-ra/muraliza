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
    let works: [Works]
    let biography: String?
    
    
    init(id: CKRecord.ID, name: String, image: Image?, works: [Works], biography: String?) {
        self.id = id
        self.name = name
        self.image = image
        self.works = works
        self.biography = biography
    }
    
}
