//
//  RecentlyAddedSection.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 31/10/24.
//

import SwiftUI

struct RecentlyAddedSection: View {
    
    @Binding var works: [(String, Int)]
    var numberOfRows: Int {
        return min(works.count, 4)
    }
    
    var body: some View {
        
        Section {
            ForEach(0..<numberOfRows, id: \.self) { index in
                HStack {
                    Text(works[index].0)
                    
                    Spacer()
                    
                    StatusComponent(status: works[index].1)
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
    RecentlyAddedSection(works: .constant([("Bomb rua 2", 1), ("Untitled", 0), ("Grafite colorido", 2)]))
}
