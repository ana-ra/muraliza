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
                }
                else {
                    if !favorites.isEmpty  {
                        GridSubview(workRecords: $favorites, title: nil, showCard: $showCard, cardWorkId: .constant(""))
                    } else {
                        Text("Não há obras salvas")
                    }
                }
            }.task {
                do {
                    
                    //TODO: fazer request apenas da tumbnail
                    self.favorites = try await workService.fetchListOfWorksFromListOfIds(IDs: user.first?.favoritesId)
                    self.isLoading = false
                } catch {
                    print("Error fetching favorites \(error.localizedDescription)")
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
    FavoritesView()
}
