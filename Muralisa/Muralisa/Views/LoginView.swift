//
//  Login.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 25/11/24.
//
import AuthenticationServices
import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @Query var user: [User]
    var swiftDataService = SwiftDataService()
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    
                    switch result {
                    case .success(let auth):
                        
                        switch auth.credential {
                        case let credential as ASAuthorizationAppleIDCredential:
                            let email = credential.email
                            let name = credential.fullName?.description
                            let userId = credential.user
                            let username = credential.user
                            
                            if user.first != nil {
                                swiftDataService.deleteAllUsers(context: context)
                            }
                            swiftDataService.createUser(id: userId, name: name, username: username, email: email, context: context)
                            
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
                
            }.navigationTitle("Login")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss() // Fecha a view
                        }) {
                            Image(systemName: "xmark")
                                .font(.headline)
                        }
                    }
                }
        }
    }
}

#Preview {
    LoginView()
}
