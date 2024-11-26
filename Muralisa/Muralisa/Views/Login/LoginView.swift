//
//  Login.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 25/11/24.
//
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
                LoginWithAppleButton()
                
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
