//
//  WorkDetailView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 31/10/24.
//

import SwiftUI
import WrappingHStack

struct WorkDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var manager = CachedArtistManager()
    @StateObject var workService: WorkService
    @State var showPopup: Bool = false
    var work: Work

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image(uiImage: work.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: getHeight() / 3)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(25)
                    .addPinchZoom()
                
                VStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Título")
                            .font(.body)
                            .fontWeight(.bold)
                        
                        if let title = work.title {
                            Text(title)
                        } else {
                            Text("Sem título")
                                .foregroundStyle(.tertiary)
                        }
                        
                        Divider()
                            .frame(height: 1)
                            .background(.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descrição")
                            .font(.body)
                            .fontWeight(.bold)
                        
                        if let description = work.workDescription {
                            Text(description)
                        } else {
                            Text("Sem descrição")
                                .foregroundStyle(.tertiary)
                        }
                        
                        Divider()
                            .frame(height: 1)
                            .background(.primary)
                    }
                        
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Artista")
                            .font(.body)
                            .fontWeight(.bold)
                        
                        if let _ = work.artist {
                            switch manager.currentState {
                            case .loading:
                                ProgressView()
                            case .success(artists: let artists):
                                WrappingHStack(alignment: .leading) {
                                    ForEach(artists, id:\.self) { artist in
                                        Text(artist.name)
                                    }
                                }
                                
                            case .failed(let error):
                                Text("Error loading artist: \(error.localizedDescription)")
                            case .unknown:
                                Text("No artist added")
                                    .foregroundStyle(.tertiary)
                            default:
                                EmptyView()
                            }
                        } else {
                            Text("No artist added")
                                .foregroundStyle(.tertiary)
                        }
                        Divider()
                            .frame(height: 1)
                            .background(.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags")
                            .font(.body)
                            .fontWeight(.bold)
                        
                        WrappingHStack(alignment: .leading) {
                            ForEach(work.tag, id: \.self) { tag in
                                Text(tag)
                                    .font(.subheadline)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 16)
                                    .background {
                                        RoundedRectangle(cornerRadius: 100)
                                            .foregroundStyle(.gray)
                                            .opacity(0.2)
                                }
                            }
                        }
                    }
                }

                HStack {
                    Spacer()
                    
                    Button("Aprovar") {
                        workService.updateStatus(of: work, to: 1)
                        workService.pendingWorkRecords.removeAll(where: { $0.recordID.recordName == work.id })
                        withAnimation {
                            showPopup = true
                        }
                    }
                    .buttonStyle(CustomBorderedProminentButtonStyle(color: .green))
                    Spacer()
                    
                    Button("Reprovar") {
                        workService.updateStatus(of: work, to: 0)
                        workService.pendingWorkRecords.removeAll(where: { $0.recordID.recordName == work.id })
                        withAnimation {
                            showPopup = true
                        }
                    }
                    .buttonStyle(CustomBorderedProminentButtonStyle(color: .red))
                    Spacer()
                }
            }
            .opacity(showPopup ? 0.1 : 1)
            .padding()
            .task {
                do {
                    try await manager.load(from: work.artist)
                } catch {
                    print("Error loading work: \(error.localizedDescription)")
                }
            }
            
            if showPopup {
                UpdatedRecordPopupView(status: work.status)
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            dismiss()
                        }
                    })
            }
        }
    }
}

//#Preview {
//    WorkDetailView()
//}
