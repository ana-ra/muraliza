//
//  artistSubview.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 21/10/24.
//

import SwiftUI
import CoreLocation

// Deve ser deletado depois.
class LocalWork {
    let id: UUID
    let title: String?
    let description: String?
    let image: UIImage
    let location: CLLocation
    let tag: [String]
    let artist: LocalArtist?
    
    init(id: UUID, title: String?, description: String?, image: UIImage, location: CLLocation, tag: [String], artist: LocalArtist?) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.location = location
        self.tag = tag
        self.artist = artist
    }
}

class LocalArtist {
    let id: UUID
    let name: String
    let image: UIImage?
    let biography: String?
    let works: [LocalWork]
    
    init(id: UUID, name: String, image: UIImage?, biography: String?, works: [LocalWork]) {
        self.id = id
        self.name = name
        self.image = image
        self.biography = biography
        self.works = works
    }
}


struct artistSubview: View {
    let work: LocalWork
    let address: String
    let distance: Double // Distance in meters
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //Artist Button
            Button {
                // Navigation to artist view
            } label: {
                HStack {
                    Label(work.artist?.name ?? "Unknown", systemImage: "person.circle")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 40)
                                .foregroundStyle(.gray)
                                .opacity(0.2)
                        }
                    Spacer()
                }
                .padding(.bottom, 8)
            }
            .disabled(work.artist == nil)
            
            // Address
            Text(address)
                .font(.title)
                .padding(.bottom, 2)
            
            // Distance
            HStack {
                Text("Esta obra está há \(distance >= 1000 ? Int(distance / 1000) : Int(distance)) \(distance >= 1000 ? "km" : "m") perto de você")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.trailing)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Ver rotas")
                }
            }
        }
        .padding()
    }
}

#Preview {
    artistSubview(work: LocalWork(id: UUID(), title: "Teste", description: "Rorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.", image: UIImage(), location: CLLocation(latitude: -22, longitude: 47), tag: ["Colorido", "Bomb", "Lettering"], artist: LocalArtist(id: UUID(), name: "Nome Teste", image: UIImage(), biography: "Rorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.", works: [])), address: "Rua Endereço Completo para pessoa achar, 7983.", distance: 1000000000)
}
