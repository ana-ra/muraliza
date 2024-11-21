//
//  TagView.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 20/11/24.
//

import SwiftUI
import CoreLocation

struct TagView: View {
    
    var tag: String
   
    var tagViewModel = TagViewModel()
    
    @State var works: [Work] = []
    @State var isLoading: Bool = true
    
    var numberOfWorks: Int {
        works.count
    }
    
    var body: some View {
        if isLoading {
            VStack {
                ProgressView()
                Text("Buscando por obras com a tag: \(tag)")
                    .foregroundStyle(Color.secondary)
            }
            .task {
                do {
                    try await tagViewModel.getWorksForTag(tag: tag)
                    self.works = tagViewModel.worksByTag
                    self.isLoading = false
                } catch {
                    print("Error in fetching works by tag: \(error.localizedDescription)")
                }
            }
        }
        else {
            ScrollView {
                VStack {
                    VStack {
                        Text("#\(tag)")
                            .foregroundStyle(Color.accentColor)
                            .font(.title)
                            .bold()
                        
                        Text("\(numberOfWorks) obras catalogadas nessa tag!")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 32)
                }
                
                GridSubview(workRecords: $works, title: nil)
            }
            .navigationTitle("Tag")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        TagView(tag: "Tag")
    }
}
