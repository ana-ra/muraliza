//
//  ContentView.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI

struct SuggestionView: View {
    @SceneStorage("isZooming") var isZooming: Bool = false
    
    @StateObject var recommendationService = RecommendationService()
    @StateObject var manager = CachedArtistManager()
    @StateObject var imageService = ImageService()
    @StateObject var viewModel = SuggestionViewModel()
    @State var isCompressed: Bool = true
    @State var isFetched: Bool = false
    @State var showArtistSheet: Bool = false
    @State var selectedArtist: Artist?
    
    var body: some View {
        NavigationStack {
            if isFetched {
                ScrollView {
                    VStack {
                        ImageSubview(work: recommendationService.todayWork, isCompressed: $isCompressed)
                            .zIndex(isZooming ? 1000 : 0)
                        DescriptionSubview(work: recommendationService.todayWork)
                        ArtistSubview(manager: manager, work: recommendationService.todayWork, address: "Rua Albertina de Jesus Martins, 35", distance: 5000, date: viewModel.distanceDate(from: recommendationService.todayWork.creationDate), showArtistSheet: $showArtistSheet, selectedArtist: $selectedArtist)
                        TagsSubView(work: recommendationService.todayWork)
                        
                        VStack(spacing: 24) {
//                            ForYouSubview(works: recommendationService.works)
//                            NextToYouSubview(works: recommendationService.works)
                            GridSubview(workRecords: recommendationService.works)
                        }
                    }
                    .animation(.easeInOut, value: isCompressed)
                }
                .navigationTitle("Sugestão")
                .toolbarBackgroundVisibility(isZooming ? .visible : .automatic, for: .navigationBar)
            } else {
                // TODO: Design Empty state view or fetching message
                Text("Fetching your daily works")
            }
        }
        .sheet(isPresented: $showArtistSheet) {
            if let selectedArtist = selectedArtist {
                ArtistSheet(artist: selectedArtist)
                    .presentationDetents([.medium, .large])
            }
        }
        .refreshable {
            Task {
                do {
                    try await recommendationService.setupRecommendation()
                    try await manager.load(from: recommendationService.todayWork.artist)
                    withAnimation {
                        isFetched.toggle()
                        isFetched.toggle()
                    }
                } catch {
                    print("deu erro \(error.localizedDescription)")
                }
            }
            print("refreshed")
        }
        .task {
            do {
                try await recommendationService.setupRecommendation()
                try await manager.load(from: recommendationService.todayWork.artist)
                withAnimation {
                    isFetched = true
                }
            } catch {
                print("deu erro \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    SuggestionView()
}
