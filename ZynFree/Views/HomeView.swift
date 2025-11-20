//
//  HomeView.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var viewModel = HomeViewModel()
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundColor(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacingXLarge) {
                        // Header
                        VStack(spacing: AppTheme.spacingSmall) {
                            QuitIcon(size: 80)
                                .padding(.bottom, AppTheme.spacingSmall)
                            
                            Text("ZynFree")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.textColor(for: colorScheme))
                            
                            if !viewModel.addictionsList.isEmpty && viewModel.addictionsList != "None" {
                                Text("You quit: \(viewModel.addictionsList)")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                            }
                        }
                        .padding(.top, AppTheme.spacingLarge)
                        
                        // Days Counter Card
                        VStack(spacing: AppTheme.spacing) {
                            Text("Days Since Quitting")
                                .font(.headline)
                                .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                            
                            Text("\(viewModel.daysSinceQuit)")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                        }
                        .frame(maxWidth: .infinity)
                        .cardStyle()
                        .padding(.horizontal, AppTheme.spacing)
                        
                        // Money Saved Card
                        VStack(spacing: AppTheme.spacing) {
                            Text("Total Money Saved")
                                .font(.headline)
                                .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                            
                            Text(viewModel.formattedMoneySaved)
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                        }
                        .frame(maxWidth: .infinity)
                        .cardStyle()
                        .padding(.horizontal, AppTheme.spacing)
                        
                        // Motivational Message
                        VStack(spacing: AppTheme.spacingSmall) {
                            QuitIcon(size: 50)
                            
                            Text(getMotivationalMessage())
                                .font(.body)
                                .foregroundColor(AppTheme.textColor(for: colorScheme))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, AppTheme.spacingLarge)
                        
                        Spacer()
                    }
                    .padding(.bottom, AppTheme.spacingXLarge)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(viewModel: SettingsViewModel())
                    .onDisappear {
                        viewModel.loadData()
                    }
            }
            .onAppear {
                viewModel.loadData()
            }
        }
    }
    
    private func getMotivationalMessage() -> String {
        let days = viewModel.daysSinceQuit
        switch days {
        case 0:
            return "You're weak and undiciplined. Today is the first day of your journey. 😈"
        case 1...7:
            return "You're \(days) day\(days == 1 ? "" : "s") in. Don't be a weak bitch. 🫵🏳️‍🌈"
        case 8...30:
            return "You've made it past the first week. I know you wanna cave pussy. 🫠"
        case 31...90:
            return "Over a month! Hard part done. 🎉"
        case 91...365:
            return "Three months and counting! You might be him. 🌟"
        default:
            return "You've been quit for over a year! You did it. 🎊 🎉"
        }
    }
}

#Preview {
    HomeView()
}

