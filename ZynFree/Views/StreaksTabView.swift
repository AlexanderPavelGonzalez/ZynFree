//
//  StreaksTabView.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct StreaksTabView: View {
    @State private var viewModel = StreaksViewModel()
    @State private var showNewStreak = false
    
    var body: some View {
        TabView {
            CurrentStreaksView(viewModel: viewModel)
                .tabItem {
                    Label("Current", systemImage: "flame.fill")
                }
            
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
        .sheet(isPresented: $showNewStreak) {
            AddStreakView(
                onSave: { addictions, quitDate, unitsPerWeek, costPerUnit in
                    viewModel.startStreaks(addictions: addictions, quitDate: quitDate, unitsPerWeek: unitsPerWeek, costPerUnit: costPerUnit)
                }
            )
        }
    }
}

#Preview {
    StreaksTabView()
}

