//
//  ArtistSheet.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 29/10/24.
//

import SwiftUI

let socialLinks: [String] = ["www.google.com", "linkedin.com/in/gustavo-santos21"]
let urlLinks: [URL] = socialLinks.compactMap { URL(string: "https://www.instagram.com/\($0)")}

struct ArtistSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var artist: Artist
    
    @State private var biography: String = ""
    @State private var socialMedia: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                HStack {
                    Text(artist.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.gray)
                            .font(.title)
                    }
                }
                .padding(.bottom, 16)
                
                if biography == "" && socialMedia == "" {
                    
                    
                    VStack {
                        Image(.unknownArtist)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.brandingSecondary)
                            .scaledToFit()
                            .opacity(0.4)
                        
                        Text("Informações sobre o artista")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .bold()
                            .padding(.bottom, 8)
                        
                        Text("Não foram encontradas em nosso banco de informações.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 16)
                    }
                    
                } else {
                    
                    if let biography = artist.biography, biography != "" {
                        VStack(alignment: .leading) {
                            Text("Sobre")
                                .font(.body)
                                .fontWeight(.semibold)
                                .padding(.bottom, 16)
                            
                            Text(biography)
                                .font(.body)
                                .fontWeight(.regular)
                                .padding(.bottom, 40)
                        }
                    }
                    
                    if let instaHandle = artist.instagram, let instaLink = URL(string: "https://www.instagram.com/\(instaHandle)") {
                        VStack(alignment: .leading) {
                            Text("Redes Sociais")
                                .font(.body)
                                .fontWeight(.semibold)
                                .padding(.bottom, 16)
                            
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundStyle(.black)
                                Link(destination: instaLink, label: {
                                    Text("@\(instaHandle)")
                                })
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                if let biography = artist.biography {
                    self.biography = biography
                }
                
                if let socialMedia = artist.instagram {
                    self.socialMedia = socialMedia
                }
                
                Spacer()
            }
        }
        .padding(16)
    }
}

#Preview {
    ArtistSheet(artist: Artist(id: "", name: "Test", image: nil, biography: "", works: ["394-13", "qjfaspo"], instagram: ""))
}
