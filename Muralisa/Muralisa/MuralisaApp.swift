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
                Tab("Sugestão", systemImage: "wand.and.rays.inverse") {
                    SuggestionView()
                }
                
                Tab("Curadoria", systemImage: "rectangle.and.text.magnifyingglass") {
                    CurationView()
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
