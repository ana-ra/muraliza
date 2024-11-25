import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var works: [Work] = []
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -22.8312, longitude: -47.0445), // Barão Geraldo, Campinas
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var userLocation: CLLocation? = CLLocation(
        latitude: -22.8312, longitude: -47.0445
    ) // Localização simulada

    var cloudKitService = CloudKitService()

    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: works) { work in
                MapAnnotation(coordinate: work.location.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.purple)
                        Text(work.title ?? "Untitled")
                            .font(.caption)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                    }
                }
            }
            .onAppear {
                fetchPins()
            }
        }
    }

    private func fetchPins() {
        guard let userLocation = userLocation else { return }
        
        Task {
            do {
                let fetchedPins = try await cloudKitService.fetchPinsByDistance(
                    ofType: Work.recordType,
                    userPosition: userLocation,
                    radius: 10000 
                )
                
                DispatchQueue.main.async {
                    self.works = fetchedPins
                }
            } catch {
                print("Error fetching pins: \(error)")
            }
        }
    }
}
