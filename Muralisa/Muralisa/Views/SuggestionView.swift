//
//  ContentView.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI

struct SuggestionView: View {
    @SceneStorage("isZooming") var isZooming: Bool = false
    @StateObject var locationManager = LocationManager()
    @StateObject var recommendationService = RecommendationService()
    @StateObject var manager = CachedArtistManager()
    @State var isCompressed: Bool = true
    @State var isFetched: Bool = false
    @State var showArtistSheet: Bool = false
    @State var selectedArtist: Artist?
    @State var address: String = ""
    @State var distance: Double = -1
    @State private var mostrarPerfil = false
    let locationService = LocationService()
    
    var body: some View {
        NavigationStack {
            if isFetched {
                ScrollView {
                    VStack {
                        ImageSubview(work: recommendationService.todayWork, isCompressed: $isCompressed)
                            .zIndex(isZooming ? 1000 : 0)
                        DescriptionSubview(work: recommendationService.todayWork)
                        ArtistSubview(locationService: locationService,
                                      locationManager: locationManager,
                                      manager: manager,
                                      workLocation: recommendationService.todayWork.location,
                                      address: $address,
                                      distance: $distance,
                                      date: distanceDate(from: recommendationService.todayWork.creationDate),
                                      showArtistSheet: $showArtistSheet, selectedArtist: $selectedArtist)
                        TagsSubView(work: recommendationService.todayWork)
                        
                        VStack(spacing: 24) {
                            if !recommendationService.worksByTodaysArtist.isEmpty {
                                MoreFromSubview(works: $recommendationService.worksByTodaysArtist)
                            }
                            
                            if !recommendationService.nearbyWorks.isEmpty {
                                NextToYouSubview(works: recommendationService.nearbyWorks)
                            }
                            
                            if !recommendationService.similarTagsWorks.isEmpty {
                                GridSubview(workRecords: $recommendationService.similarTagsWorks)
                            }
                        }
                    }
                    .animation(.easeInOut, value: isCompressed)
                }
                .navigationTitle("Sugestão")
                .toolbarBackgroundVisibility(isZooming ? .visible : .automatic, for: .navigationBar)
            } else {
                // TODO: Design Empty state view or fetching message
                ProgressView("Fetching your daily works")
            }
        }
        .sheet(isPresented: $showArtistSheet) {
            if let selectedArtist = selectedArtist {
                ArtistSheet(artist: selectedArtist)
                    .presentationDetents([.medium, .large])
            }
        }
        .refreshable {
            await fetchData()
            print("refreshed")
        }
        .task {
            await fetchData()
            print("refreshed")
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    mostrarPerfil.toggle()
                }) {
                    Image(systemName: "person.crop.circle.fill")
                }
                .sheet(isPresented: $mostrarPerfil) {
                    PerfilView()
                }
            }
        }
    }
}

#Preview {
    SuggestionView()
}
