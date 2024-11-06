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
                print(address)
            case .failure(let error):
                self.address = "Couldn't resolve address :("
            }
        }
        
        if let myLocation = locationManager.location {
            print("entrou")
            withAnimation {
                self.distance = locationService.calculateDistance(from: myLocation, to: work.location)
            }
        }
    }
}
