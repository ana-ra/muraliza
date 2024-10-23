//
//  ContentView.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var recommendationService = RecommendationService()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            if let title = recommendationService.todayWork.title {
                Text(title)
            }
            
            if let description = recommendationService.todayWork.workDescription {
                Text(description)
            }
            
           Image(uiImage: recommendationService.todayWork.image)
                .resizable()
                .scaledToFit()
        }
        .padding()
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

#Preview {
    ContentView()
}
