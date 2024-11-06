//
//  NewWorkCardView.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 05/11/24.
//

import SwiftUI
import WrappingHStack
import CoreLocation

struct NewWorkCardView: View {
    
    var artist: String
    var title: String
    var descripition: String
    
    var image: UIImage?
    var location: CLLocation?
    
    @State private var tags: [String] = []
    
    @State private var showTagsModal: Bool = false
    
    var body: some View {
        VStack {
            
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: getWidth() - 80)
                        .frame(maxHeight: tags.isEmpty ? getHeight()/3.2 : getHeight()/4.2)
                        .cornerRadius(20)
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                        .clipped()
                }
                
                HStack {
                    Text("Artista:")
                    Text(artist == "" ? "Desconhecido" : artist)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                Group {
                    Divider()
                        .frame(height: 0.3)
                        .overlay(Color.black)
                }
                .frame(width: getWidth() - 80)
                .padding(.bottom, 4)
                
                HStack {
                    
                    Text("Título:")
                    Text(title)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                Group {
                    Divider()
                        .frame(height: 0.305)
                        .overlay(Color.black)
                }
                .frame(width: getWidth() - 80)
                .padding(.bottom, 4)
                
                
                WrappingHStack(alignment: .leading) {
                    
                    Text("Descrição:")
                    Text(descripition == "" ? "Sem descrição" : descripition)
                        .bold()
                        .lineLimit(1)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, tags.isEmpty ? 24 : 0)
                
                
                
                if !tags.isEmpty {
                    
                    Group {
                        Divider()
                            .frame(height: 0.3)
                            .overlay(Color.black)
                    }
                    .frame(width: getWidth() - 80)
                    .padding(.bottom, 18)
                    
                    HStack(spacing: 24) {
                        
                        ForEach(tags, id: \.self) { tag in
                            
                            Text("\(tag)")
                                .font(.subheadline)
                                .foregroundStyle(Color.accentColor)
                                .frame(width: (getWidth() - (32 + 48 + 48)) / 3)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .foregroundStyle(Color.accentColor)
                                        .opacity(0.15)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
            }
            .frame(width: getWidth() - 32)
            .frame(maxHeight: getHeight()/1.8)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color(red: 255/256, green: 237/256, blue: 237/256))
                }
            )
            .padding(.vertical, 24)
        
            
            HStack {
                Spacer()
                Text("Adicione uma tag para enviar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            
            HStack {
                Spacer()
                Button {
                    showTagsModal = true
                } label: {
                    Text("Adicionar Tag")
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .foregroundStyle(.gray)
                                .opacity(0.15)
                        )
                }
                .sheet(isPresented: $showTagsModal) {
                    AddTagsSheet(selectedTags: $tags)
                }
                
                Spacer()
            }
            .padding(.bottom, 12)
            
            
            HStack {
                Spacer()
                Button {
                    // Adicionar no banco
                } label: {
                    Label("Enviar", systemImage: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.accentColor)
                        )
                }
                .disabled(tags.isEmpty)
                Spacer()
            }
            
            Spacer()
            
        }
        .navigationTitle("Revisar")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        NewWorkCardView(artist: "",title: "Tropical gang", descripition: "", image: UIImage(named: "ima"))
    }
}
