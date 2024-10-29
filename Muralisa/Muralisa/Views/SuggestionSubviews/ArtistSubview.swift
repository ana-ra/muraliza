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
    @State var date: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    switch manager.currentState {
                    case .loading:
                        ProgressView()
                    case .success(artists: let artists):
                        WrappingHStack(alignment: .leading) {
                            ForEach(artists, id:\.self) { artist in
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
                }
                
                //Insertion date
                HStack {
                    Image(systemName: "calendar")
                    Text(date)
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            Spacer()
            
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
        .padding()
    }
}
