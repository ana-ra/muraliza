//
//  ArtistSheet.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 29/10/24.
//

import SwiftUI

let socialLinks: [String] = ["www.google.com", "linkedin.com/in/gustavo-santos21"]
let urlLinks: [URL] = socialLinks.compactMap { URL(string: "https://\($0)")}

struct ArtistSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var artist: Artist
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
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
//                            .scaleEffect(1.5)
                    }
                    
                }
                
                if let biography = artist.biography, biography != "" {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sobre")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Text(biography)
                            .font(.body)
                            .fontWeight(.regular)
                    }
                }
                
                if let instaHandle = artist.instagram, let instaLink = URL(string: "https://\(instaHandle)") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Redes Sociais")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "globe")
                                .foregroundStyle(.black)
                            Link(destination: instaLink, label: {
                                /// Drops the 'https://'
                                Text("@\(instaHandle)")
                            })
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    // Seguir
                } label: {
                    Text("Seguir")
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
        .padding(16)
    }
}

#Preview {
    ArtistSheet(artist: Artist(id: "", name: "Test", image: nil, biography: "This is the biography", works: ["394-13", "qjfaspo"], instagram: "gustavo_sacramento"))
}
