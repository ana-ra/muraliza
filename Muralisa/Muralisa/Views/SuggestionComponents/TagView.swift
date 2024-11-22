//
//  TagView.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 20/11/24.
//

import SwiftUI
import CoreLocation

struct TagView: View {
    
    var tag: String
   
    var tagViewModel = TagViewModel()
    let workService = WorkService()
    let artistService = ArtistService()
    
    @State var works: [Work] = []
    @State var isLoading: Bool = true
    
    @State var showCard: Bool = false
    @State var loadingCardView: Bool = true
    @State var cardWorkId: String = ""
    @State var cardWork: Work?
    @State var artistList: String = ""
    
    
    var numberOfWorks: Int {
        works.count
    }
    
    var body: some View {
        if isLoading {
            VStack {
                Spacer()
                GifView(gifName: "fetchInicial")
                    .aspectRatio(contentMode: .fit)
                    .frame(height: getHeight()/5)
                Spacer()
            }
            .task {
                do {
                    try await tagViewModel.getWorksForTag(tag: tag)
                    self.works = tagViewModel.worksByTag
                    self.isLoading = false
                } catch {
                    print("Error in fetching works by tag: \(error.localizedDescription)")
                }
            }
        }
        else {
            ZStack {
                ScrollView {
                    VStack {
                        VStack {
                            Text("#\(tag)")
                                .foregroundStyle(Color.accentColor)
                                .font(.title)
                                .bold()
                            
                            Text("\(numberOfWorks) obras catalogadas nessa tag!")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 32)
                    }
                    
                    GridSubview(workRecords: $works, title: nil, showCard: $showCard, cardWorkId: $cardWorkId)
                }
                .navigationTitle("Tag")
                .navigationBarTitleDisplayMode(.inline)
                .opacity(showCard ? 0.1 : 1)
                .animation(.easeInOut, value: showCard)
                .onChange(of: showCard) {
                    if showCard == false {
                        loadingCardView = true
                    }
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
}

extension TagView {
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
    NavigationStack {
        TagView(tag: "Tag")
    }
}
