//
//  artistSubview.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 21/10/24.
//

import SwiftUI
import CoreLocation
import WrappingHStack

struct ArtistSubview: View {
    @StateObject var manager: CachedArtistManager
    @State var isFetched: Bool = false
    @State var work: Work
    @State var address: String
    @State var distance: Double // Distance in meters
    @Binding var showArtistSheet: Bool
    @Binding var selectedArtist: Artist?
    
    var body: some View {
        VStack(alignment: .leading) {
            switch manager.currentState {
            case .loading:
                ProgressView()
            case .success(artists: let artists):
                WrappingHStack(alignment: .leading) {
                    ForEach(artists, id:\.self) { artist in
                        //Artist Button
                        Button {
                            withAnimation(.easeInOut) {
                                showArtistSheet = true
                            }
                            selectedArtist = artist
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
                    }
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
                .disabled(true)
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
//        .task {
//            do {
//                try await manager.load(from: work.artist)
//                isFetched = true
//            } catch {
//                print("error loading work: \(error.localizedDescription)")
//            }
//        }
        .padding()
    }
}