//
//  Untitled.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 22/11/24.
//

import SwiftUI
import SwiftData

struct ContribuitionsView: View {
    @Environment(\.dismiss) var dismiss
    @State var contribution: [Work] = []
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
                    if !contribution.isEmpty  {
                        GridSubview(workRecords: $contribution, title: nil, showCard: $showCard, cardWorkId: .constant(""))
                    } else {
                        Text("Não há obras salvas")
                    }
                }
            }.task {
                do {
                    self.contribution = try await workService.fetchListOfWorksFromListOfIds(IDs: user.first?.contributionsId)
                    self.isLoading = false
                } catch {
                    print("Error fetching contribuitions \(error.localizedDescription)")
                }
            }
            .navigationBarTitle(Text("Contribuições"), displayMode: .inline)
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
    ContribuitionsView()
}
