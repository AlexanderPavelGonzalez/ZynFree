//
//  ZynFreeApp.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

@main
struct ZynFreeApp: App {
    @State private var hasCompletedOnboarding: Bool
    
    init() {
        // Initialize onboarding state - check if user has streaks
        let store = LocalDataStore.shared.loadStreakStore()
        let hasStreaks = !store.activeStreaks.isEmpty || !store.completedStreaks.isEmpty
        _hasCompletedOnboarding = State(initialValue: hasStreaks)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    StreaksTabView()
                } else {
                    AddStreakView(hasCompletedOnboarding: $hasCompletedOnboarding)
                }
            }
            .preferredColorScheme(nil) // Respect system color scheme
        }
    }
}

