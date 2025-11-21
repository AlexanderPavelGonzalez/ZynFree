//
//  Streak.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import Foundation

struct Streak: Identifiable, Codable {
    let id: UUID
    var name: String               // e.g. "Nicotine", "Vape", "Gym", etc.
    var startDate: Date
    var endDate: Date?             // nil = still active
    var unitsPerWeek: Int          // How many units per week
    var costPerUnit: Double        // Cost per unit
    
    init(id: UUID = UUID(), name: String, startDate: Date, endDate: Date? = nil, unitsPerWeek: Int = 0, costPerUnit: Double = 0.0) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.unitsPerWeek = unitsPerWeek
        self.costPerUnit = costPerUnit
    }
    
    // Computed property for days active/duration
    var daysActive: Int {
        let calendar = Calendar.current
        let startOfStart = calendar.startOfDay(for: startDate)
        let endDateToUse = endDate ?? Date()
        let startOfEnd = calendar.startOfDay(for: endDateToUse)
        return calendar.dateComponents([.day], from: startOfStart, to: startOfEnd).day ?? 0
    }
    
    var totalDaysDuration: Int {
        guard let endDate = endDate else { return 0 }
        let calendar = Calendar.current
        let startOfStart = calendar.startOfDay(for: startDate)
        let startOfEnd = calendar.startOfDay(for: endDate)
        return calendar.dateComponents([.day], from: startOfStart, to: startOfEnd).day ?? 0
    }
    
    var isActive: Bool {
        endDate == nil
    }
    
    // Money tracking
    var totalMoneySaved: Double {
        guard unitsPerWeek > 0 && costPerUnit > 0 else { return 0.0 }
        let daysToUse = isActive ? daysActive : totalDaysDuration
        let weeks = Double(daysToUse) / 7.0
        return weeks * Double(unitsPerWeek) * costPerUnit
    }
    
    var formattedMoneySaved: String {
        String(format: "$%.2f", totalMoneySaved)
    }
}

struct StreakStore: Codable {
    var activeStreaks: [Streak]
    var completedStreaks: [Streak]
    
    init(activeStreaks: [Streak] = [], completedStreaks: [Streak] = []) {
        self.activeStreaks = activeStreaks
        self.completedStreaks = completedStreaks
    }
}

