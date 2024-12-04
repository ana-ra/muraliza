import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var works: [Work] = []
    
    private let initialPosition: MapCameraPosition = .userLocation(
        fallback: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: -22.8312, longitude: -47.0445), distance: 10000))
    )
    
    @State private var userLocation: CLLocation? = CLLocation(
        latitude: -22.8312, longitude: -47.0445
    )
    
    @State private var showCard: Bool = false
    @State private var loadingCardView: Bool = true
    @State private var selectedWorkId: String = ""
    @State private var selectedWork: Work?
    @State private var artistList: String = ""
    
    let workService = WorkService()
    let artistService = ArtistService()
    let cloudKitService = CloudKitService()

    var body: some View {
        ZStack {
            Map(initialPosition: initialPosition) {
                ForEach(works) { work in
                    Annotation("Artwork", coordinate: work.location.coordinate) {
                        VStack {
                            Image("pin")
                                .onTapGesture {
                                    selectedWorkId = work.id // Armazena o ID da obra
                                    showCard = true
                                    loadingCardView = true
                                }
                        }
                    }
                }
                
                UserAnnotation()
            }
            .opacity(showCard ? 0.1 : 1)
            .animation(.easeInOut, value: showCard)
            .onAppear {
                fetchPins()
            }

            if showCard {
                if loadingCardView {
                    VStack {
                        Spacer()
                        GifView(gifName: "fetchInicial")
                            .aspectRatio(contentMode: .fit)
                            .frame(height: getHeight() / 5)
                        Spacer()
                    }
                    .onAppear {
                        Task {
                            await loadCardDetails(workId: selectedWorkId)
                        }
                    }
                } else if let selectedWork = selectedWork {
                    CardView(
                        image: selectedWork.image,
                        artist: artistList,
                        title: selectedWork.title ?? "",
                        description: selectedWork.workDescription ?? "",
                        location: selectedWork.location,
                        tags: .constant(selectedWork.tag),
                        showCloseButton: true,
                        showBottomElement: .route,
                        showCard: $showCard
                    )
                    .zIndex(1)
                }
            }
        }
    }

    private func fetchPins() {
        guard let userLocation = locationManager.location else { return }
        
        Task {
            do {
                let fetchedPins = try await cloudKitService.fetchPinsByDistance(
                    ofType: Work.recordType,
                    userPosition: userLocation,
                    radius: 10000 // 10 km
                )
                
                DispatchQueue.main.async {
                    self.works = fetchedPins
                }
            } catch {
                print("Error fetching pins: \(error)")
            }
        }
    }
    
    private func loadCardDetails(workId: String) async {
        do {
            // Busca a obra pelo ID
            let work = try await workService.fetchWorkFromRecordName(from: workId)
            self.selectedWork = work
            
            // Busca os artistas relacionados
            if let artists = work.artist {
                var artistNames: [String] = []
                for artistRef in artists {
                    do {
                        let artist = try await artistService.fetchArtistFromReference(artistRef)
                        artistNames.append(artist.name)
                    } catch {
                        print("Erro ao buscar artista: \(error.localizedDescription)")
                    }
                }
                self.artistList = artistNames.joined(separator: ", ")
            } else {
                self.artistList = "Desconhecido"
            }

            
            loadingCardView = false
        } catch {
            print("Error loading card details: \(error.localizedDescription)")
            showCard = false
        }
    }
}
