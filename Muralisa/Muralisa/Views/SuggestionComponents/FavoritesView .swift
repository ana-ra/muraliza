//
//  Untitled.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 22/11/24.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.dismiss) var dismiss
    @State var favorites: [Work] = []
    @Query var user: [User]
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationStack {
            VStack {
                if !favorites.isEmpty  {
                    GridSubview(workRecords: $favorites)
                } else {
                    Text("Não há obras salvas")
                }
            }
            .navigationBarTitle(Text("Curtidas"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Pronto")
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContributionsView()
}
