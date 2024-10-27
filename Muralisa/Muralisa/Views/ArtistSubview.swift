//
//  artistSubview.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 21/10/24.
//

import SwiftUI
import CoreLocation

struct ArtistSubview: View {
    let work: Work
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
