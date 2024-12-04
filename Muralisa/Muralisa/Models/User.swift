//
//  User.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 21/11/24.
//

import SwiftData
import SwiftUI

@Model
class User {
    var id: String?
    var name: String?
    var email: String?
    var notifications: Bool = true
    @Attribute(.externalStorage) var photo: Data?
    var favoritesId: [String]? = []
    var contributionsId: [String]? = []
    
    init(id: String? = nil, name: String? = nil, email: String? = nil, notifications: Bool, photo: Data? = nil, favoritesId: [String]? = nil, contributionsId: [String]? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.notifications = notifications
        self.photo = photo
        self.favoritesId = favoritesId
        self.contributionsId = contributionsId
    }
    
}
