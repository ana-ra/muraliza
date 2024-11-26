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
    var workService = WorkService()
    @State var countApprovedWorks = 0
    @State var countRejectedWorks = 0
    @State var countPendingWorks = 0
    
    
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
                                
                            //Editar Photo Button
                            Button {

                                //TODO: trocar imagem ao clicar no botão (precisa implementar troca dos outros dados tbm)
                                
                            } label: {
                                Text("Editar foto")
                                    .font(.subheadline)
                            }
                            
                            //name
                            if let user = user.first, let name = user.name  {
                                Text(name)
                                    .font(.title3)
                                    .bold()
                                    .padding(.top, 8)
                            } else {
                                Text("Nome desconhecido")
                                    .font(.title3)
                                    .bold()
                                    .padding(.top, 8)
                            }
                            
                            //username
                            if let username = user.first?.username {
                                Text(String("@\(username)"))
                            } else {
                                Text("Username desconhecido")
                            }
                        
                            //email
                            if let email = user.first?.email {
                                Text(String(email))
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                            } else {
                                Text("Email desconhecido")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                            }

                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                
                Section {
                    ProfileCardSubview(approvedWorks: countApprovedWorks,
                                       pendingWorks: countPendingWorks,
                                       rejectedWorks: countRejectedWorks,
                                       title: "Art Hunter")
                }
                
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
                            ContribuitionsView()
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
                
                Section {
                    Button {
                        print(user)
                        swiftDataService.deleteAllUsers(context: context)
                        print(user)
                    } label: {
                        HStack {
                            Spacer()
                            Text("Finalizar sessão")
                                .foregroundColor(.red)
                            Spacer()
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
        }.onAppear {
            Task {
                if let user = self.user.first, let contributionsId = user.contributionsId {
                    print("contributionsId", contributionsId)
                    do {
                        self.countPendingWorks = try await workService.fetchCountOfWorksStatus(IDs: contributionsId,
                                                                                               status: 2)
                        self.countApprovedWorks = try await workService.fetchCountOfWorksStatus(IDs: contributionsId,
                                                                                                status: 1)
                        self.countRejectedWorks = try await workService.fetchCountOfWorksStatus(IDs: contributionsId,
                                                                                                status: 0)
                    } catch {
                        print("Error counting works status \(error.localizedDescription)")
                    }
                }
                
            }
        }
    }
}

#Preview {
    PerfilView()
}

