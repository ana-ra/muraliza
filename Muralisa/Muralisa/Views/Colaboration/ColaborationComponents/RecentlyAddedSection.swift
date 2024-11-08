//
//  RecentlyAddedSection.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 31/10/24.
//

import SwiftUI

struct RecentlyAddedSection: View {
    
    var works: [(String, Int, UUID)]
    
    var body: some View {
        
        Section {
            ForEach(works, id: \.2) { work in
                HStack {
                    Text(work.0)
                    
                    Spacer()
                    
                    StatusComponent(status: work.1)
                }
                .listRowSeparator(.visible)
            }
        } header: {
            Text("Adicionadas recentemente")
        } footer: {
            Text("Lista das obras adicionadas por você recentemente, com status de Aprovada, Pendente ou Reprovada.")
        }
    }
    
}


#Preview {
    RecentlyAddedSection(works: [("Bomb rua 2", 1, UUID()), ("Untitled", 0, UUID()), ("Grafite colorido", 2, UUID()), ("Wild hardcore", 0, UUID())])
}
