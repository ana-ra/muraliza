//
//  modelWork.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 15/10/24.
//

import SwiftUI
import CoreLocation
import CloudKit

class Work: NSObject, Identifiable {
    static let recordType: String = "Artwork"
    
    static func == (lhs: Work, rhs: Work) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let title: String?
    let workDescription: String?
    let image: UIImage?
    let imageThumb: UIImage
    let location: CLLocation
    let tag: [String]
    let artist: [CKRecord.Reference]?
    let creationDate: Date
    var status: Int
    
    init(id: String, title: String?, workDescription: String?, image: UIImage?, imageThumb: UIImage, location: CLLocation, tag: [String], artist: [CKRecord.Reference]?, creationDate: Date, status: Int) {
        self.id = id
        self.title = title
        self.workDescription = workDescription
        self.image = image
        self.imageThumb = imageThumb
        self.location = location
        self.tag = tag
        self.artist = artist
        self.creationDate = creationDate
        self.status = status
    }
    
    convenience init(id: String, title: String?, location: CLLocation) {
           self.init(
               id: id,
               title: title,
               workDescription: nil,
               image: nil,
               imageThumb: UIImage(systemName: "photo")!,
               location: location,
               tag: [],
               artist: nil,
               creationDate: Date(),
               status: 1
           )
       }
}
