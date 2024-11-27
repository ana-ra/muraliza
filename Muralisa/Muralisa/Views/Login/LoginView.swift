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
    @Binding var showLogin: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Você não está com a sessão iniciada")
                    .font(.body).bold()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
                
                Text("Faça o login com a sua conta Apple para poder colaborar com o movimento da arte urbana!")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                LoginWithAppleButton()
                    .frame(width: getWidth()*0.7, height: 50)
                    .padding(.horizontal)
                
                Button {
                    dismiss() // Fecha a view
                    showLogin = false
                } label: {
                    Text("Continuar sem o login")
                        .foregroundStyle(.accent)
                }.padding(.top, 8)

                Spacer()
                
            }.navigationTitle("Login")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
        }
    }
}
