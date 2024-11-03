//
//  SuggestionViewModel.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 29/10/24.
//
import SwiftUI
import Foundation

class SuggestionViewModel: ObservableObject {
    
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
}
