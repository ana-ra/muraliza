//
//  SuggestionViewModel.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 29/10/24.
//
import SwiftUI
import Foundation

extension SuggestionView {
    func distanceDate(from data: Date) -> String {
        let today = Date()
        let calendar = Calendar.current

        let diferenceYears = calendar.dateComponents([.year], from: data, to: today).year ?? 0
        let diferenceMonths = calendar.dateComponents([.month], from: data, to: today).month ?? 0
        let diferenceDays = calendar.dateComponents([.day], from: data, to: today).day ?? 0

        if diferenceYears > 1 {
            return "Há \(diferenceYears) anos"
        } else if diferenceYears == 1{
            return "Há \(diferenceYears) ano"
        } else if diferenceMonths > 1 {
            return "Há \(diferenceMonths) meses"
        } else if diferenceMonths == 1{
            return "Há \(diferenceMonths) mês"
        } else if diferenceDays > 1 {
            return "Há \(diferenceDays) dias"
        } else if diferenceDays == 1 {
            return "Há \(diferenceDays) dia"
        } else {
            return "Há menos de 1 dia"
        }
    }
    
    func fetchData() async {
        do {
            try await recommendationService.setupDailyRecommendation()
            try await manager.load(from: recommendationService.todayWork.artist)
            try await recommendationService.setupRecommendationByTags()
            try await recommendationService.setupRecommendationByDistance(userPosition: locationManager.location)
            setupLocation(for: recommendationService.todayWork)
            try await recommendationService.fetchWorksByArtist()
            withAnimation { isFetched = true }
        } catch {
            print("deu erro \(error.localizedDescription)")
        }
    }
    
    func setupLocation(for work: Work) {
        // Just to indicate it's loading
        address = ""
        distance = -1
        
        locationService.getAddress(from: work.location) { result in
            switch result {
            case .success(let address):
                withAnimation {
                    self.address = address
                }
            case .failure(let error):
                self.address = "Couldn't resolve address :("
            }
        }
        
        if let myLocation = locationManager.location {
            withAnimation {
                self.distance = locationService.calculateDistance(from: myLocation, to: work.location)
            }
        }
    }
    
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
