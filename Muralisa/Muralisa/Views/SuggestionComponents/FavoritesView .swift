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
    @State var showCard = false
    var workService = WorkService()
    
    @State var isLoading = true
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if isLoading {
                    VStack {
                        Spacer()
                        GifView(gifName: "fetchInicial")
                            .aspectRatio(contentMode: .fit)
                            .frame(height: getHeight()/5)
                        Spacer()
                    }
                    .task {
                        //TODO: fazer o request das obras e mudar status do loading
                    }
                }
                else {
                    
                    if !favorites.isEmpty  {
                        GridSubview(workRecords: $favorites, title: nil, showCard: $showCard, cardWorkId: .constant(""))
                    } else {
                        Text("Não há obras salvas")
                    }
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
