//
//  CurationArtworkListView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 31/10/24.
//

import SwiftUI

struct CurationArtworkListView: View {
    @StateObject var workService: WorkService
    @StateObject var manager = CachedWorkManager()
    
    var body: some View {
        List {
            Section {
                ForEach(workService.pendingWorkRecords, id: \.self) { record in
                    HStack {
                        CachedWorkListItemView(workService: workService, recordName: record.recordID.recordName, transition: .scale.combined(with: .opacity))
                            .padding(.trailing, 16)
                    }
                    .listRowInsets(EdgeInsets()) 
                }
            } header: {
                Text("Imagens para a aprovação")
            } footer: {
                Text("Clique em detalhes para obter mais informações sobre a obra analisada e aprovar ou reprová-la do repositório de imagens.")
            }
        }
    }
}
