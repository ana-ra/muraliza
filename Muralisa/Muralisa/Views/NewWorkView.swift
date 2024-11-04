//
//  NewWorkView.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 01/11/24.
//

import SwiftUI
import CoreLocation

struct NewWorkView: View {
    
    var image: UIImage?
    var location: CLLocation?
    
    @State private var artist: String = ""
    
    @State private var title: String = ""
    @State private var description: String = ""
    
    @State private var navigate: Bool = false
    
    var body: some View {
        List {
            Section {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: getHeight()/2.5)
                        .frame(width: getWidth() - 16)
                        .padding(.horizontal, -16)
                        .cornerRadius(20)
                        .listRowBackground(Color.clear)
                }
            }
            
            Section {
                HStack {
                    HStack {
                        Text("Artista")
                        Spacer()
                    }
                    .frame(width: 100)
                    
                    TextField("Untitled", text: $artist)
                }
            }
            
            Section {
                HStack {
                    HStack {
                        Text("Título")
                        Spacer()
                    }
                    .frame(width: 100)
                    
                    TextField("Opcional", text: $title)
                }
                
                HStack {
                    HStack {
                        Text("Descrição")
                        Spacer()
                    }
                    .frame(width: 100)
                    
                    TextField("Unknown", text: $description)
                }
            } header: {
                Text("Sobre a obra")
            }
            
            
            Section {
                HStack {
                    Spacer()
                    Text("Revisar")
                        .foregroundStyle(title.isEmpty ? Color.secondary : .white)
                        .padding(.horizontal)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(title.isEmpty ? .gray : .accent)
                                .opacity(title.isEmpty ? 0.25 : 1)
                        )
                        .onTapGesture {
                            if !title.isEmpty {
                                navigate = true
                            }
                        }
                    Spacer()
                }
                .listRowBackground(Color.clear)

                
                HStack {
                    Spacer()
                    Text("Tirar outra foto")
                        .foregroundStyle(.accent)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listSectionSpacing(16)
        .navigationTitle("Editar")
    }
}


#Preview {
    NewWorkView(image: UIImage(named: "ima"), location: CLLocation(latitude: -24, longitude: 48))
}
