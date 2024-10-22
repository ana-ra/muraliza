//
//  RecommendationService.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 21/10/24.
//

import SwiftUI

class RecommendationService {
    var works: [Work] = []
    var workService = WorkService()
    let defaults = UserDefaults.standard
    
    init() {
        works = workService.fetchWorks()
        self.printWorks()
    }
    
    func printWorks(){
        print(works)
    }
    
    
}
