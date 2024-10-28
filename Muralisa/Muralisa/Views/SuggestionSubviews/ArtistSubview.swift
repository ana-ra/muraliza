//
//  artistSubview.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 21/10/24.
//

import SwiftUI
import CoreLocation

struct ArtistSubview: View {
    @StateObject private var manager = CachedArtistManager()
    @State var isFetched: Bool = false
    let work: Work
    let address: String
    let distance: Double // Distance in meters
    
    var body: some View {
        VStack(alignment: .leading) {
            switch manager.currentState {
            case .loading:
                ProgressView()
            case .success(artist: let artist):
                //Artist Button
                Button {
                    // Navigation to artist view
                } label: {
                    HStack {
                        Label(artist.name, systemImage: "person.circle")
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
            case .failed(let error):
                Text("Error loading artist: \(error.localizedDescription)")
            case .unknown:
                //Artist Button
                Button {
                    // Navigation to artist view
                } label: {
                    HStack {
                        Label("Unknown", systemImage: "person.circle")
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
            default:
                EmptyView()
            }
            
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
        .animation(.easeInOut, value: manager.currentState)
        .task {
            do {
                try await manager.load(from: work.artist?.recordID.recordName)
                isFetched = true
            } catch {
                print("error loading work: \(error.localizedDescription)")
            }
        }
        .padding()
    }
}
