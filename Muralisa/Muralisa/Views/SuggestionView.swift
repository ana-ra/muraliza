//
//  ContentView.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var recommendationService = RecommendationService()
    @StateObject var imageService = ImageService()
    @State var isCompressed: Bool = true
    @State var isFetched: Bool = false
    
    var body: some View {
        NavigationStack {
            if isFetched {
                ScrollView {
                    VStack {
                        ImageSubview(work: recommendationService.todayWork, isCompressed: $isCompressed)
                        ArtistSubview(work: recommendationService.todayWork, address: "Rua Albertina de Jesus Martins, 35", distance: 5000)
                        TagsSubView(work: recommendationService.todayWork)
                        VStack(spacing: 24) {
                            ForYouSubview()
                            NextToYouSubview()
                            GridSubview()
                        }
                    }
                    .animation(.easeInOut, value: isCompressed)
                }
                .navigationTitle("Sugestão")
            } else {
                // TODO: Design Empty state view or fetching message
                Text("Fetching your daily works")
            }
        }
        .refreshable {
            Task {
                do {
                    try await recommendationService.setupRecommendation2()
                    try await imageService.populate()
                } catch {
                    print("deu erro \(error)")
                    print("deu erro \(error.localizedDescription)")
                }
            }
            print("refreshed")
        }
        .task {
            do {
                try await recommendationService.setupRecommendation2()
                try await imageService.populate()
                isFetched = true
            } catch {
                print("deu erro \(error)")
                print("deu erro \(error.localizedDescription)")
            }
        }
    }
    
}

#Preview {
    ContentView()
}
