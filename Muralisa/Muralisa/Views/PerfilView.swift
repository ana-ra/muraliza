//
//  Untitled.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 19/11/24.
//
import SwiftUI

struct PerfilView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationOn = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section {

                    HStack {
                        Spacer()
                        VStack {
                            Image("ima")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: getHeight()/5)

                            
                            Button {
                                print("teste")
                            } label: {
                                Text("Editar foto")
                                    .font(.subheadline)
                            }
                            
                            Text("Camila Alves")
                                .font(.title3)
                                .bold()
                                .padding(.top, 8)

                            Text("@ca.aalves")
                            Text(String("camalv33@gmail.com"))
                                .font(.subheadline)
                                .foregroundStyle(Color.gray)
                                .padding(.top, 8)
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                Section {
                    HStack {
                        Toggle("Notificações", isOn: $notificationOn)
                    }
                }
                
                Section {
                    NavigationLink {
                        PerfilView()
                    } label: {
                        HStack {
                            Text("Contribuições")
                            Spacer()
                            Text("Detalhes")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink {
                        PerfilView()
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

