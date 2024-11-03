//
//  CachedWorkListView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 31/10/24.
//

import SwiftUI

struct CachedWorkListItemView: View {
    @StateObject var workService: WorkService
    @StateObject private var manager = CachedWorkManager()
    let recordName: String
    let transition: AnyTransition
    
    var body: some View {
        HStack {
            switch manager.currentState {
            case .loading:
                HStack {
                    ProgressView()
                        .frame(width: 100, height: 100)
                        .transition(transition)
                    
                    Text("Loading ...")
                }
                
            case .success(work: var work):
                if work.status == 2 {
                    NavigationLink(destination: WorkDetailView(workService: workService, work: work)) {
                        HStack {
                            Image(uiImage: work.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 72, height: 72)
                                .cornerRadius(0.001)
                                .transition(transition)
                            
                            if let title = work.title {
                                Text(title)
                                    .font(.body)
                            } else {
                                Text("Untitled")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            Text("Detalhes")
                                .font(.body)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
            case .failed(let _):
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .frame(maxWidth: 100)
                    .cornerRadius(16)
            default:
                ProgressView()
                    .frame(width: 100, height: 100)
                    .transition(transition)
            }
        }
        .animation(.easeInOut, value: manager.currentState)
        .task {
            do {
                try await manager.load(from: recordName)
            } catch {
                print("error loading work: \(error.localizedDescription)")
            }
        }
    }
}

//#Preview {
//    CachedWorkListItemView()
//}
