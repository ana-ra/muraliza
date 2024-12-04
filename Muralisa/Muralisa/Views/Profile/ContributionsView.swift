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
    
    var workService = WorkService()
    var artistService = ArtistService()
    
    @State var isLoading = true
    
    @State var showCard = false
    @State var loadingCardView = true
    @State var cardWorkId: String = ""
    @State var cardWork: Work?
    @State var artistList: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if isLoading {
                    VStack {
                        Spacer()
                        GifView(gifName: "fetchInicial")
                            .aspectRatio(contentMode: .fit)
                            .frame(height: getHeight()/5)
                            .task {
                                do {
                                    self.contribution = try await workService.fetchListOfWorksFromListOfIds(IDs: user.first?.contributionsId)
                                    self.isLoading = false
                                } catch {
                                    print("Error fetching contribuitions \(error.localizedDescription)")
                                }
                            }
                        Spacer()
                    }
                }
                else {
                    ZStack {
                        if !contribution.isEmpty  {
                            GridSubview(workRecords: $contribution, title: nil, showCard: $showCard, cardWorkId: $cardWorkId)
                                .opacity(showCard ? 0.1 : 1)
                                .animation(.easeInOut, value: showCard)
                                .onChange(of: showCard) {
                                    if showCard == false {
                                        loadingCardView = true
                                    }
                                }
                        } else {
                            Text("Não há obras salvas")
                        }
                        
                        if showCard {
                            if loadingCardView {
                                VStack {
                                    Spacer()
                                    GifView(gifName: "fetchInicial")
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: getHeight()/5)
                                    Spacer()
                                }
                                .onAppear {
                                    Task {
                                        await getCardWorkById(cardWorkId: cardWorkId)
                                        loadingCardView = false
                                    }
                                }
                            } else {
                                if let cardWork = cardWork {
                                    CardView(image: cardWork.image, artist: artistList, title: cardWork.title ?? "", description: cardWork.workDescription ?? "", location: cardWork.location, tags: .constant(cardWork.tag), showCloseButton: true, showBottomElement: .route, showCard: $showCard)
                                }
                            }
                        }
                    }
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

extension ContribuitionsView {
    func getCardWorkById(cardWorkId: String) async {
        do {
        let work = try await workService.fetchWorkFromRecordName(from: cardWorkId)
            if let artists = work.artist {
                for index in 0..<artists.count {
                    let artist = try await artistService.fetchArtistFromReference(artists[index])
                    if index == 0 {
                        self.artistList = artist.name
                    } else {
                        self.artistList += ", \(artist.name)"
                    }
                }
            } else {
                self.artistList = ""
            }
            
            self.cardWork = work
            
            
        } catch {
            print("Error fetching cardWork: \(error.localizedDescription)")
            showCard = false
        }
    }
}

#Preview {
    ContribuitionsView()
}
