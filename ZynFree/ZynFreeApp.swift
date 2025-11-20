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
        // Initialize onboarding state
        _hasCompletedOnboarding = State(initialValue: LocalDataStore.shared.hasCompletedOnboarding())
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    HomeView()
                } else {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                }
            }
            .preferredColorScheme(nil) // Respect system color scheme
        }
    }
}

