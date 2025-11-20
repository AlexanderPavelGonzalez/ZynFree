//
//  HomeViewModel.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class HomeViewModel {
    var addictionData: AddictionData?
    
    init() {
        loadData()
    }
    
    func loadData() {
        addictionData = LocalDataStore.shared.load()
    }
    
    var daysSinceQuit: Int {
        addictionData?.daysSinceQuit ?? 0
    }
    
    var totalMoneySaved: Double {
        addictionData?.totalMoneySaved ?? 0.0
    }
    
    var formattedMoneySaved: String {
        String(format: "$%.2f", totalMoneySaved)
    }
    
    var addictionsList: String {
        guard let addictions = addictionData?.addictions, !addictions.isEmpty else {
            return "None"
        }
        return addictions.joined(separator: ", ")
    }
}

