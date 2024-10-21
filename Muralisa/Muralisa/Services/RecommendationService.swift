//
//  RecommendationService.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 21/10/24.
//

class RecommendationService {
    var works: [Work] = []
    
    var workService = WorkService()
    
    init() {
        works = workService.fetchWorks()
        
    }
}
