//
//  SettingsViewModel.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class SettingsViewModel {
    var addictionData: AddictionData?
    
    var selectedAddictions: Set<String>
    var quitDate: Date
    var unitsPerWeek: String
    var costPerUnit: String
    
    let availableAddictions = AppConstants.availableAddictions
    
    init() {
        if let existingData = LocalDataStore.shared.load() {
            addictionData = existingData
            selectedAddictions = Set(existingData.addictions)
            quitDate = existingData.quitDate
            unitsPerWeek = String(existingData.unitsPerWeek)
            costPerUnit = String(format: "%.2f", existingData.costPerUnit)
        } else {
            selectedAddictions = []
            quitDate = Date()
            unitsPerWeek = ""
            costPerUnit = ""
        }
    }
    
    var canSave: Bool {
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
        saveChanges()
    }
    
    func updateQuitDate(_ date: Date) {
        quitDate = date
        saveChanges()
    }
    
    func updateUnitsPerWeek(_ value: String) {
        unitsPerWeek = value
        saveChanges()
    }
    
    func updateCostPerUnit(_ value: String) {
        costPerUnit = value
        saveChanges()
    }
    
    private func saveChanges() {
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
        
        addictionData = data
        LocalDataStore.shared.update(data)
    }
}

