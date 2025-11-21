//
//  StreaksViewModel.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class StreaksViewModel {
    var activeStreaks: [Streak] = []
    var completedStreaks: [Streak] = []
    
    init() {
        loadStreaks()
    }
    
    // MARK: - Loading and Saving
    
    func loadStreaks() {
        let store = LocalDataStore.shared.loadStreakStore()
        activeStreaks = store.activeStreaks
        completedStreaks = store.completedStreaks
    }
    
    private func saveStreaks() {
        let store = StreakStore(
            activeStreaks: activeStreaks,
            completedStreaks: completedStreaks
        )
        LocalDataStore.shared.saveStreakStore(store)
    }
    
    // MARK: - Streak Management
    
    func startStreak(name: String, startDate: Date = Date(), unitsPerWeek: Int = 0, costPerUnit: Double = 0.0) {
        let newStreak = Streak(name: name, startDate: startDate, unitsPerWeek: unitsPerWeek, costPerUnit: costPerUnit)
        activeStreaks.append(newStreak)
        saveStreaks()
    }
    
    func startStreaks(addictions: Set<String>, quitDate: Date, unitsPerWeek: Int, costPerUnit: Double) {
        for addiction in addictions {
            let newStreak = Streak(name: addiction, startDate: quitDate, unitsPerWeek: unitsPerWeek, costPerUnit: costPerUnit)
            activeStreaks.append(newStreak)
        }
        saveStreaks()
    }
    
    func endStreak(id: UUID) {
        guard let index = activeStreaks.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        var streak = activeStreaks[index]
        streak.endDate = Date()
        
        // Remove from active
        activeStreaks.remove(at: index)
        
        // Add to completed (sorted by end date, newest first)
        completedStreaks.insert(streak, at: 0)
        completedStreaks.sort { (streak1, streak2) in
            let date1 = streak1.endDate ?? Date.distantPast
            let date2 = streak2.endDate ?? Date.distantPast
            return date1 > date2
        }
        
        saveStreaks()
    }
    
    func renameStreak(id: UUID, newName: String) {
        if let index = activeStreaks.firstIndex(where: { $0.id == id }) {
            activeStreaks[index].name = newName
            saveStreaks()
        }
    }
    
    func deleteActiveStreak(id: UUID) {
        activeStreaks.removeAll { $0.id == id }
        saveStreaks()
    }
    
    func deleteCompletedStreak(id: UUID) {
        completedStreaks.removeAll { $0.id == id }
        saveStreaks()
    }
}

