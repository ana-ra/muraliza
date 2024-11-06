//
//  CachedWorkView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 27/10/24.
//

import SwiftUI

struct CachedWorkImage<Content: View>: View {
    @StateObject private var manager = CachedWorkManager()
    let workRecordName: String
    let animation: Animation?
    let transition: AnyTransition
    let content: (AsyncImagePhase) -> Content
    
    init(
        workRecordName: String,
        animation: Animation? = nil,
        transition: AnyTransition = .opacity,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.workRecordName = workRecordName
        self.animation = animation
        self.transition = transition
        self.content = content
    }
    
    var body: some View {
        ZStack {
            switch manager.currentState {
            case .loading:
                content(.empty)
                    .transition(transition)
            // In case of success, can substitute this view with our own view
            // Ideally, it would probably be a Navigation link to the page of each work
            case .success(work: let work):
                content(.success(Image(uiImage: work.image)))
                    .transition(transition)
            case .failed(let error):
                content(.failure(error))
                    .transition(transition)
            default:
                content(.empty)
                    .transition(transition)
            }
        }
        .animation(animation, value: manager.currentState)
        .task {
            do {
                try await manager.load(from: workRecordName)
            } catch {
                print("error loading work: \(error.localizedDescription)")
            }
        }
    }
}

//#Preview {
//    CachedWorkView()
//}
