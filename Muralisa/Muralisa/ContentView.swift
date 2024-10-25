//
//  ContentView.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var recommendationService = RecommendationService()
    @State var isCompressed: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ImageSubview(work: recommendationService.todayWork, isCompressed: $isCompressed)
                    ArtistSubview(work: recommendationService.todayWork, address: "Rua Albertina de Jesus Martins, 35", distance: 5000)
                    TagsSubView(work: recommendationService.todayWork)
                    VStack(spacing: 24) {
                        ForYouSubview()
                        NextToYou()
                        GridSubview()
                    }
                }
                .animation(.easeInOut, value: isCompressed)
            }
            .navigationTitle("Sugestão")
            .task {
                do {
                    try await recommendationService.setupRecommendation()
                } catch {
                    print("deu erro \(error)")
                    print("deu erro \(error.localizedDescription)")
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
