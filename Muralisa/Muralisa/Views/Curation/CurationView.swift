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
    
    var body: some View {
        NavigationStack {
            VStack {
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
            }
            .navigationTitle("Curadoria")
            .navigationBarTitleDisplayMode(!workService.pendingWorkRecords.isEmpty ? .inline : .large)
        }
        .refreshable {
            Task {
                do {
                    try await workService.fetchPendingWorkRecords()
                } catch {
                    print("Error fetching pending works: \(error)")
                }
            }
            
            print("refreshed")
        }
        .task {
            do {
                try await workService.fetchPendingWorkRecords()
                print("Fetched Records: \(workService.pendingWorkRecords.count)")
            } catch {
                print("Error fetching pending works: \(error)")
            }
        }
    }
}
