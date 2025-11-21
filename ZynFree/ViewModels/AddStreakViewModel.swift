//
//  AddStreakViewModel.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class AddStreakViewModel {
    var selectedAddictions: Set<String> = []
    var quitDate: Date = Date()
    var unitsPerWeek: String = ""
    var costPerUnit: String = ""
    var isOnboarding: Bool = false
    
    let availableAddictions = AppConstants.availableAddictions
    
    var title: String {
        isOnboarding ? "Welcome to ZynFree" : "Track a New Streak"
    }
    
    var subtitle: String {
        isOnboarding ? "Let's set up your journey" : "What are you quitting?"
    }
    
    var showCancelButton: Bool {
        !isOnboarding
    }
    
    var canComplete: Bool {
        !selectedAddictions.isEmpty
    }
    
    func toggleAddiction(_ addiction: String) {
        if selectedAddictions.contains(addiction) {
            selectedAddictions.remove(addiction)
        } else {
            selectedAddictions.insert(addiction)
        }
    }
    
    func reset() {
        selectedAddictions = []
        quitDate = Date()
        unitsPerWeek = ""
        costPerUnit = ""
    }
    
    func completeOnboarding() {
        // Create a streak for each selected addiction
        let store = LocalDataStore.shared.loadStreakStore()
        var updatedStore = store
        
        let unitsPerWeekInt = Int(unitsPerWeek) ?? 0
        let costPerUnitDouble = Double(costPerUnit) ?? 0.0
        
        // Add streaks for each selected addiction
        for addiction in selectedAddictions {
            let streak = Streak(
                name: addiction,
                startDate: quitDate,
                unitsPerWeek: unitsPerWeekInt,
                costPerUnit: costPerUnitDouble
            )
            updatedStore.activeStreaks.append(streak)
        }
        
        // Save the updated streak store
        LocalDataStore.shared.saveStreakStore(updatedStore)
    }
}

