//
//  Untitled.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 22/11/24.
//

import SwiftUI
import SwiftData

struct ContributionsView: View {
    @Environment(\.dismiss) var dismiss
    @State var contributions: [Work] = []
    @Query var user: [User]
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationStack {
            VStack {
                if !contributions.isEmpty  {
                    GridSubview(workRecords: $contributions)
                } else {
                    Text("Não há obras salvas")
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
    ContributionsView()
}
