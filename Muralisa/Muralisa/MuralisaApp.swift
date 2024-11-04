//
//  MuralisaApp.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI

@main
struct MuralisaApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SuggestionView()
                    .tabItem {
                        Label("Sugestão", systemImage: "wand.and.rays.inverse")
                    }
                
                ColaborationView()
                    .tabItem {
                        Label("Colaborar", systemImage: "square.and.arrow.up")
                    }
            }
        }
    }
}

extension View {
    func getHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
