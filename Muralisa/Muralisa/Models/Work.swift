//
//  modelWork.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//
import Foundation
import CloudKit

class Work {
    static let recordType = "Work"
    private let id : CKRecord.ID

    let Title: String
    let Description: String
    let Image: CKAsset
    let Location: CLLocation
    let Style: String
    let Artist: Artist?
    
    init(id: CKRecord.ID, Title: String, Description: String, Image: CKAsset, Location: CLLocation, Style: String, Artist: Artist?) {
        self.id = id
        self.Title = Title
        self.Description = Description
        self.Image = Image
        self.Location = Location
        self.Style = Style
        self.Artist = Artist
    }
}
