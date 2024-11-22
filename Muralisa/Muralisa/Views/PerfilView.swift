//
//  Untitled.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 19/11/24.
//
import SwiftUI
import SwiftData

struct PerfilView: View {
    @Environment(\.dismiss) var dismiss
    @State var isNotificationOn = true
    @Query var user: [User]
    @Environment(\.modelContext) var context
    var swiftDataService = SwiftDataService()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {

                    HStack {
                        Spacer()
                        VStack {
                            
                            //photo
                            if let photoData = user.first?.photo, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: getHeight() / 6)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: getHeight()/5)
                            }
                                
                            //Editar Butto
                            Button {
                                swiftDataService.createTestUser(context: context)
                            } label: {
                                Text("Editar foto")
                                    .font(.subheadline)
                            }
                            
                            //name
                            if let name = user.first?.name {
                                Text(name)
                                    .font(.title3)
                                    .bold()
                                    .padding(.top, 8)
                            } else {
                                Text("Desconhecido")
                                    .font(.title3)
                                    .bold()
                                    .padding(.top, 8)
                            }
                            
                            //usernmae
                            if let username = user.first?.username {
                                Text(String("@\(username)"))
                            }
                        
                            //email
                            if let email = user.first?.email {
                                Text(String(email))
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                                    .padding(.top, 8)
                            }

                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                Section {
                    HStack {
                        if let notificationOn = user.first?.notifications {
                            Toggle("Notificações", isOn: $isNotificationOn)
                                .onAppear{
                                    isNotificationOn = notificationOn}
                                .onChange(of: isNotificationOn) {
                                    user.first?.notifications = isNotificationOn
                                }
                        } else {
                            Toggle("Notificações", isOn: $isNotificationOn)
                        }
                    }
                }
                
                if user.first != nil {
                    Section {
                        NavigationLink {
                            ContributionsView()
                        } label: {
                            HStack {
                                Text("Contribuições")
                                Spacer()
                                Text("Detalhes")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        NavigationLink {
                            FavoritesView()
                        } label: {
                            HStack {
                                Text("Curtidas")
                                Spacer()
                                Text("Detalhes")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                    }
                }

            }
            .navigationBarTitle(Text("Perfil"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Pronto")
                    }
                }
            }
        }
    }
}

#Preview {
    PerfilView()
}

