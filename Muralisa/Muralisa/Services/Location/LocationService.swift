//
//  LocationService.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 01/11/24.
//

import Foundation
import CoreLocation
import MapKit

@Observable
class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let geocoder = CLGeocoder()
    
    // Calculates distance in metres
    func calculateDistance(from location1: CLLocation, to location2: CLLocation) -> CLLocationDistance {
        return location1.distance(from: location2)
    }
    
    // Converts a CLLocation into a human-readable address string.
    func getAddress(from location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            // Handles possible errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(NSError(domain: "LocationServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No address found"])))
                return
            }
            
            // Format address from placemark details
            let address = [
                placemark.name,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ].compactMap { $0 }.joined(separator: ", ")
            
            completion(.success(address))
        }
    }
    
    // Creates two URLs to open Maps with directions between two locations.
    func getMapsLink(from startLocation: CLLocation, to destinationLocation: CLLocation) -> (appleMaps: URL?, googleMaps: URL?) {
        let startCoordinate = startLocation.coordinate
        let destinationCoordinate = destinationLocation.coordinate
        
        let appleUrlString = "http://maps.apple.com/?saddr=\(startCoordinate.latitude),\(startCoordinate.longitude)&daddr=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)"
        let googleUrlString =  "https://www.google.com/maps/dir/?api=1&origin=\(startCoordinate.latitude),\(startCoordinate.longitude)&destination=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&travelmode=driving"
        
        let appleMapsURL = URL(string: appleUrlString)
        let googleMapsURL = URL(string: googleUrlString)
        
        return (appleMaps: appleMapsURL, googleMapsURL)
    }
}
