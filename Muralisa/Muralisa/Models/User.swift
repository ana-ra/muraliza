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
    var username: String?
    var email: String?
    var notifications: Bool = true
    @Attribute(.externalStorage) var photo: Data?
    
    //TODO: Add list of favorites and list of contrbutions

    init(id: String? = nil, name: String? = nil, username: String? = nil, email: String? = nil, notifications: Bool, photo: Data? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.notifications = notifications
        self.photo = photo
    }
    
}
