//
//  OnboardingViewModel.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class OnboardingViewModel {
    var selectedAddictions: Set<String> = []
    var quitDate: Date = Date()
    var unitsPerWeek: String = ""
    var costPerUnit: String = ""
    
    let availableAddictions = AppConstants.availableAddictions
    
    var canComplete: Bool {
        !selectedAddictions.isEmpty &&
        !unitsPerWeek.isEmpty &&
        !costPerUnit.isEmpty &&
        Int(unitsPerWeek) != nil &&
        Double(costPerUnit) != nil
    }
    
    func toggleAddiction(_ addiction: String) {
        if selectedAddictions.contains(addiction) {
            selectedAddictions.remove(addiction)
        } else {
            selectedAddictions.insert(addiction)
        }
    }
    
    func completeOnboarding() {
        guard let unitsPerWeekInt = Int(unitsPerWeek),
              let costPerUnitDouble = Double(costPerUnit) else {
            return
        }
        
        let data = AddictionData(
            addictions: Array(selectedAddictions),
            quitDate: quitDate,
            unitsPerWeek: unitsPerWeekInt,
            costPerUnit: costPerUnitDouble
        )
        
        LocalDataStore.shared.save(data)
    }
}

