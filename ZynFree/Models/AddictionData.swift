//
//  AddictionData.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import Foundation

struct AddictionData: Codable {
    var addictions: [String]
    var quitDate: Date
    var unitsPerWeek: Int
    var costPerUnit: Double
    
    init(addictions: [String] = [], quitDate: Date = Date(), unitsPerWeek: Int = 0, costPerUnit: Double = 0.0) {
        self.addictions = addictions
        self.quitDate = quitDate
        self.unitsPerWeek = unitsPerWeek
        self.costPerUnit = costPerUnit
    }
    
    // Computed properties for calculations
    var daysSinceQuit: Int {
        let calendar = Calendar.current
        let startOfQuit = calendar.startOfDay(for: quitDate)
        let startOfToday = calendar.startOfDay(for: Date())
        return calendar.dateComponents([.day], from: startOfQuit, to: startOfToday).day ?? 0
    }
    
    var totalMoneySaved: Double {
        guard unitsPerWeek > 0 && costPerUnit > 0 else { return 0.0 }
        let weeksSinceQuit = Double(daysSinceQuit) / 7.0
        let unitsPerWeekDouble = Double(unitsPerWeek)
        return weeksSinceQuit * unitsPerWeekDouble * costPerUnit
    }
}

