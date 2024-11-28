//
//  SwiftDataService.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 21/11/24.
//

import SwiftData
import Foundation
import UIKit

class SwiftDataService {
    
    // MARK: - Create
    func createUser(id: String, name: String? = nil, username: String? = nil, email: String? = nil, notifications: Bool = true, photo: Data? = nil, context: ModelContext) {
        let newUser = User(id: id, name: name, email: email, notifications: notifications, photo: photo)
        context.insert(newUser)
        saveContext(context: context)
    }
    
    // MARK: - Read
    func fetchAllUsers(context: ModelContext) -> [User] {
        let fetchDescriptor = FetchDescriptor<User>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUser(byID id: String, context: ModelContext) -> User? {
        let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == id })
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            print("Failed to fetch user by ID: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Update
    func updateUser(_ user: User, withData data: [String: Any], context: ModelContext) {
        if let name = data["name"] as? String {
            user.name = name
        }

        if let email = data["email"] as? String {
            user.email = email
        }
        if let notifications = data["notifications"] as? Bool {
            user.notifications = notifications
        }
        if let photo = data["photo"] as? Data {
            user.photo = photo
        }
        saveContext(context: context)
    }
    
    // MARK: - Delete
    func deleteUser(_ user: User, context: ModelContext) {
        context.delete(user)
        saveContext(context: context)
    }
    
    func deleteAllUsers(context: ModelContext) {
        let users = fetchAllUsers(context: context)
        for user in users {
            context.delete(user)
        }
        saveContext(context: context)
    }
    
    // MARK: - Save Context
    func saveContext(context: ModelContext) {
        do {
            try context.save()
            print("Changes saved successfully!")
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
