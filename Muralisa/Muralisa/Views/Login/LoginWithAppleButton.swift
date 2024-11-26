//
//  Untitled.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 26/11/24.
//
import AuthenticationServices
import SwiftUI
import SwiftData

struct LoginWithAppleButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Query var user: [User]
    @Environment(\.modelContext) var context
    var swiftDataService = SwiftDataService()
    
    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            
            switch result {
            case .success(let auth):
                
                switch auth.credential {
                case let credential as ASAuthorizationAppleIDCredential:
                    let email = credential.email
                    let name = credential.fullName?.givenName
                    let userId = credential.user
                    
                    if user.first != nil {
                        swiftDataService.deleteAllUsers(context: context)
                    }
                    swiftDataService.createUser(id: userId, name: name, email: email, context: context)
                    
                default:
                    break
                }
                
            case .failure(let error):
                print(error)
            }
            
        }.signInWithAppleButtonStyle (
            colorScheme == .dark ? .white : .black
        )
        .frame(width: 50, height: 100)
        .padding()
        .cornerRadius(8)
    }
}
