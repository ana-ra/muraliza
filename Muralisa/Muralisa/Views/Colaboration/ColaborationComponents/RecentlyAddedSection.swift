//
//  RecentlyAddedSection.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 31/10/24.
//

import SwiftUI

struct RecentlyAddedSection: View {
    
    var works: [(String, Int, UUID)]
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
    RecentlyAddedSection(works: [("Bomb rua 2", 1, UUID()), ("Untitled", 0, UUID()), ("Grafite colorido", 2, UUID())])
}
