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
    @SceneStorage("isZooming") var isZooming: Bool = false
    @StateObject var locationService: LocationService
    @StateObject var locationManager: LocationManager
    @StateObject var manager: CachedArtistManager
    @State var isFetched: Bool = false
    @State private var dialogDetail: (URL?, URL?)
    @State private var hasRoute: Bool = false
    @State var workLocation: CLLocation
    @Binding var address: String
    @Binding var distance: Double // Distance in meters
    @State var date: String
    @Binding var showArtistSheet: Bool
    @Binding var selectedArtist: Artist?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                VStack {
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
                    Spacer()
                }
                .padding(.vertical, 8)
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            Spacer()
            
            // Address
            if address == "" {
                ProgressView()
            } else {
                Text(address)
                    .font(.title)
                    .padding(.bottom, 2)
            }
            
            // Distance
            HStack {
                if distance == -1 {
                    ProgressView()
                } else {
                    Text("Esta obra está há \(distance >= 1000 ? Int(distance / 1000) : Int(distance)) \(distance >= 1000 ? "km" : "m") perto de você")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.trailing)
                    
                    Spacer()
                    
                    Button {
                        if let location = locationManager.location {
                            dialogDetail = locationService.getMapsLink(from: location, to: workLocation)
                            hasRoute = true
                        }
                    } label: {
                        Text("Ver rotas")
                    }
                    .confirmationDialog("Abrir no Maps", isPresented: $hasRoute, titleVisibility: .visible, presenting: dialogDetail) { links in
                        if let appleMapsLink = links.0 {
                            Button {
                                UIApplication.shared.open(appleMapsLink)
                            } label: {
                                Text("Maps")
                            }
                        }
                        
                        if let googleMapsLink = links.1 {
                            Button {
                                UIApplication.shared.open(googleMapsLink)
                            } label: {
                                Text("Google Maps")
                            }
                        }
                    } message: { _ in
                        Text("Qual app você gostaria de utilizar?")
                    }
                }
            }
        }
        .animation(.easeInOut, value: manager.currentState)
        .padding()
        .task {
            // Just to indicate it's loading
            address = ""
            distance = -1
            
            locationService.getAddress(from: workLocation) { result in
                switch result {
                case .success(let address):
                    self.address = address
                case .failure:
                    self.address = "Couldn't resolve address :("
                }
            }
            
            if let myLocation = locationManager.location {
                withAnimation {
                    self.distance = locationService.calculateDistance(from: myLocation, to: workLocation)
                }
            }
        }
    }
}
