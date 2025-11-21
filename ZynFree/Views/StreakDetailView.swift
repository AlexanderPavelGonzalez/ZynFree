//
//  StreakDetailView.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct StreakDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    let streak: Streak
    let viewModel: StreaksViewModel
    
    @State private var showRenameAlert = false
    @State private var renameText = ""
    @State private var showEndStreakConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.spacingXLarge) {
                // Header with Icon
                VStack(spacing: AppTheme.spacingSmall) {
                    QuitIcon(size: 80)
                        .padding(.bottom, AppTheme.spacingSmall)
                    
                    Text(streak.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppTheme.spacingLarge)
                
                // Days Counter Card
                VStack(spacing: AppTheme.spacing) {
                    Text(streak.isActive ? "Days Since Quitting" : "Total Days")
                        .font(.headline)
                        .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                    
                    Text("\(streak.isActive ? streak.daysActive : streak.totalDaysDuration)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                }
                .frame(maxWidth: .infinity)
                .cardStyle()
                .padding(.horizontal, AppTheme.spacing)
                
                // Money Saved Card (if applicable)
                if streak.unitsPerWeek > 0 && streak.costPerUnit > 0 {
                    VStack(spacing: AppTheme.spacing) {
                        Text("Total Money Saved")
                            .font(.headline)
                            .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                        
                        Text(streak.formattedMoneySaved)
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                    }
                    .frame(maxWidth: .infinity)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacing)
                }
                
                // Date Information Card
                VStack(alignment: .leading, spacing: AppTheme.spacing) {
                    Text("Timeline")
                        .font(.headline)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                    
                    VStack(alignment: .leading, spacing: AppTheme.spacingSmall) {
                        HStack {
                            Text("Started:")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                            Spacer()
                            Text(formatDate(streak.startDate))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.textColor(for: colorScheme))
                        }
                        
                        if let endDate = streak.endDate {
                            HStack {
                                Text("Ended:")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                                Spacer()
                                Text(formatDate(endDate))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                            }
                        }
                        
                        if streak.unitsPerWeek > 0 && streak.costPerUnit > 0 {
                            Divider()
                                .padding(.vertical, AppTheme.spacingSmall)
                            
                            HStack {
                                Text("Units per week:")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                                Spacer()
                                Text("\(streak.unitsPerWeek)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                            }
                            
                            HStack {
                                Text("Cost per unit:")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                                Spacer()
                                Text(String(format: "$%.2f", streak.costPerUnit))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                            }
                        }
                    }
                }
                .cardStyle()
                .padding(.horizontal, AppTheme.spacing)
                
                // Motivational Message
                if streak.isActive {
                    VStack(spacing: AppTheme.spacingSmall) {
                        QuitIcon(size: 50)
                        
                        Text(getMotivationalMessage())
                            .font(.body)
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, AppTheme.spacingLarge)
                    
                    // Action Buttons for Active Streaks
                    VStack(spacing: AppTheme.spacing) {
                        Button(action: {
                            renameText = streak.name
                            showRenameAlert = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Rename")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primaryColor(for: colorScheme))
                            .cornerRadius(AppTheme.cornerRadius)
                        }
                        
                        Button(action: {
                            showEndStreakConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("End Streak")
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(AppTheme.cornerRadius)
                        }
                    }
                    .padding(.horizontal, AppTheme.spacing)
                } else {
                    // Completion message for ended streaks
                    VStack(spacing: AppTheme.spacingSmall) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                        
                        Text("Streak Completed")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                        
                        Text("You made it \(streak.totalDaysDuration) days!")
                            .font(.body)
                            .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                    }
                    .padding(.vertical, AppTheme.spacingLarge)
                }
                
                Spacer(minLength: AppTheme.spacingLarge)
            }
            .padding(.bottom, AppTheme.spacingXLarge)
        }
        .background(AppTheme.backgroundColor(for: colorScheme))
        .navigationBarTitleDisplayMode(.inline)
        .alert("Rename Streak", isPresented: $showRenameAlert) {
            TextField("Name", text: $renameText)
            Button("Cancel", role: .cancel) {
                renameText = ""
            }
            Button("Save") {
                viewModel.renameStreak(id: streak.id, newName: renameText)
                renameText = ""
            }
        } message: {
            Text("Enter a new name for this streak")
        }
        .alert("End Streak", isPresented: $showEndStreakConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("End Streak", role: .destructive) {
                viewModel.endStreak(id: streak.id)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to end this streak? It will be moved to history.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func getMotivationalMessage() -> String {
        let days = streak.daysActive
        switch days {
        case 0:
            return "You're weak and undisciplined. Today is the first day of your journey. 😈"
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
    NavigationStack {
        StreakDetailView(
            streak: Streak(name: "Nicotine Pouches", startDate: Date().addingTimeInterval(-86400 * 30), unitsPerWeek: 20, costPerUnit: 8.50),
            viewModel: StreaksViewModel()
        )
    }
}

