//
//  CurationView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 31/10/24.
//

import SwiftUI
import CloudKit

struct CurationView: View {
    @StateObject var workService = WorkService()
    @State var isFetched: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if isFetched {
                    if !workService.pendingWorkRecords.isEmpty {
                        CurationArtworkListView(workService: workService)
                    } else {
                        VStack(alignment: .center, spacing: 8) {
                            Text("Você está em dia!")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
                            Text("Não há nenhuma nova obra que necessite de curadoria.")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                } else {
                    ProgressView("Fetching works to curate...")
                }
            }
            .navigationTitle("Curadoria")
            .navigationBarTitleDisplayMode(!workService.pendingWorkRecords.isEmpty ? .inline : .large)
        }
        .refreshable {
            await fetchData()
            print("refreshed")
        }
        .task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            try await workService.fetchPendingWorkRecords()
            withAnimation { isFetched = true }
        } catch {
            print("Error fetching pending works: \(error)")
        }
    }
}
