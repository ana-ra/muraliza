//
//  ContentView.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI
import SwiftData
import CoreLocation
import Shimmer

struct SuggestionView: View {
    @SceneStorage("isZooming") var isZooming: Bool = false
    @StateObject var locationManager = LocationManager()
    @StateObject var recommendationService = RecommendationService()
    @StateObject var manager = CachedArtistManager()
    @State var isCompressed: Bool = true
    @State var isFetched: Bool = false
    @State var showArtistSheet: Bool = false
    @State var selectedArtist: Artist?
    @State var address: String = ""
    @State var distance: Double = -1
    @State private var mostrarPerfil = false
    let locationService = LocationService()
    let workService = WorkService()
    let artistService = ArtistService()
    
    @State var navigateToTagView: Bool = false
    @State var selectedTag: String = ""
    
    @State var showCard: Bool = false
    @State var cardWorkId: String = ""
    @State var loadingCardView: Bool = true
    @State var cardWork: Work?
    @State var artistList: String = ""
    @Query var user: [User]
    @State var showLogin = false
    
    private var workPlaceholder: Work = Work(id: "", title: "Title", workDescription: "Description placeholder", image: UIImage(resource: .perfilPhoto), imageThumb: UIImage(resource: .perfilPhoto), location: CLLocation(latitude: -24, longitude: 43), tag: ["Tipografia", "Color", "Psicodélico"], artist: nil, creationDate: Date(), status: 2)
    
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isFetched {
                    ScrollView {
                        VStack {
                            ImageSubview(work: recommendationService.todayWork, isCompressed: $isCompressed)
                                .zIndex(isZooming ? 1000 : 0)
                            DescriptionSubview(work: recommendationService.todayWork)
                            ArtistSubview(locationService: locationService,
                                          locationManager: locationManager,
                                          manager: manager,
                                          workLocation: recommendationService.todayWork.location,
                                          address: $address,
                                          distance: $distance,
                                          date: distanceDate(from: recommendationService.todayWork.creationDate),
                                          showArtistSheet: $showArtistSheet, selectedArtist: $selectedArtist)
                            TagsSubView(work: recommendationService.todayWork, navigateToTagView: $navigateToTagView, selectedTag: $selectedTag)
                                .navigationDestination(isPresented: $navigateToTagView) {
                                    TagView(tag: selectedTag)
                                }
                            
                            VStack(spacing: 24) {
                                if !recommendationService.worksByTodaysArtist.isEmpty {
                                    MoreFromSubview(works: $recommendationService.worksByTodaysArtist, showCard: $showCard, cardWorkId: $cardWorkId)
                                }
                                
                                if !recommendationService.nearbyWorks.isEmpty {
                                    NextToYouSubview(works: recommendationService.nearbyWorks, showCard: $showCard, cardWorkId: $cardWorkId)
                                }
                                
                                if !recommendationService.similarTagsWorks.isEmpty {
                                    GridSubview(workRecords: $recommendationService.similarTagsWorks, title: "Similares", showCard: $showCard, cardWorkId: $cardWorkId)
                                }
                            }
                        }
                        .animation(.easeInOut, value: isCompressed)
                    }
                    .navigationTitle("Sugestão")
                    .toolbarBackground(isZooming ? .visible : .automatic, for: .navigationBar)
                    .opacity(showCard ? 0.1 : 1)
                    .animation(.easeInOut, value: showCard)
                   
                } else {
                    ScrollView {
                        VStack {
                            ImageSubview(work: workPlaceholder, isCompressed: $isCompressed)
                            DescriptionSubview(work: workPlaceholder)
                            ArtistSubview(locationService: locationService,
                                          locationManager: locationManager,
                                          manager: manager,
                                          workLocation: workPlaceholder.location,
                                          address: .constant("Av. Barão de Itapura, 1123 - Botafogo, Campinas - SP"),
                                          distance: .constant(11500),
                                          date: "Há menos de 1 dia",
                                          showArtistSheet: .constant(false), selectedArtist: $selectedArtist)
                            TagsSubView(work: workPlaceholder, navigateToTagView: .constant(false), selectedTag: .constant(""))
                            
                        }
                        .navigationTitle("Sugestão")
                        .redacted(reason: .placeholder)
                        .shimmering()
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
//                        .toolbar(.hidden, for: .navigationBar)
//                        .toolbar(.hidden, for: .tabBar)
                        .onAppear {
                            Task {
                                await getCardWorkById(cardWorkId: cardWorkId)
                                loadingCardView = false
                            }
                        }
                        
                    } else {
                        if let cardWork = cardWork {
                            CardView(image: cardWork.image, artist: artistList, title: cardWork.title ?? "", description: cardWork.workDescription ?? "",location: cardWork.location, tags: .constant(cardWork.tag), showCloseButton: true, showBottomElement: .route, showCard: $showCard)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(showLogin: $showLogin)
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingTab(showOnboarding: $showOnboarding)
        }
        .onChange(of: showCard) {
            if showCard == false {
                loadingCardView = true
                artistList = ""
            }
        }
        .sheet(isPresented: $showArtistSheet) {
            if let selectedArtist = selectedArtist {
                ArtistSheet(artist: selectedArtist)
                    .presentationDetents([.medium, .large])
            }
        }
        .task {
            if recommendationService.initialFetchDone == false {
                await fetchData()
                print("refreshed")
                recommendationService.initialFetchDone = true
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if user.first == nil {
                        showLogin = true
                    } else {
                        mostrarPerfil.toggle()
                    }
                }) {
                    if user.first != nil {
                        Image("PerfilPhoto")
                            .resizable()
                            .frame(width: 32,height: 32,alignment: .trailing)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 32,height: 32,alignment: .trailing)
                            .clipShape(Circle())
                    }
                }
                .sheet(isPresented: $mostrarPerfil) {
                    PerfilView(showLogin: $showLogin)
                }
            }
        }
    }
}

#Preview {
    SuggestionView()
}
