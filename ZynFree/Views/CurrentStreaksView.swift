//
//  CurrentStreaksView.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct CurrentStreaksView: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var viewModel: StreaksViewModel
    @State private var showNewStreak = false
    @State private var streakToRename: Streak? = nil
    @State private var renameText = ""
    @State private var showRenameAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundColor(for: colorScheme)
                    .ignoresSafeArea()
                
                if viewModel.activeStreaks.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: AppTheme.spacing) {
                            ForEach(viewModel.activeStreaks) { streak in
                                NavigationLink(destination: StreakDetailView(streak: streak, viewModel: viewModel)) {
                                    ActiveStreakCard(
                                        streak: streak,
                                        onEnd: {
                                            viewModel.endStreak(id: streak.id)
                                        },
                                        onRename: {
                                            streakToRename = streak
                                            renameText = streak.name
                                            showRenameAlert = true
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(AppTheme.spacing)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewStreak = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showNewStreak) {
                AddStreakView(
                    onSave: { addictions, quitDate, unitsPerWeek, costPerUnit in
                        viewModel.startStreaks(addictions: addictions, quitDate: quitDate, unitsPerWeek: unitsPerWeek, costPerUnit: costPerUnit)
                    }
                )
            }
            .alert("Rename Streak", isPresented: $showRenameAlert) {
                TextField("Name", text: $renameText)
                Button("Cancel", role: .cancel) {
                    streakToRename = nil
                    renameText = ""
                }
                Button("Save") {
                    if let streak = streakToRename {
                        viewModel.renameStreak(id: streak.id, newName: renameText)
                        streakToRename = nil
                        renameText = ""
                    }
                }
            } message: {
                Text("Enter a new name for this streak")
            }
            .onAppear {
                viewModel.loadStreaks()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.spacingLarge) {
            QuitIcon(size: 100)
                .padding(.bottom, AppTheme.spacingSmall)
            
            Text("No Active Streaks")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.textColor(for: colorScheme))
            
            Text("Tap the + button to start tracking a new streak")
                .font(.body)
                .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.spacingLarge)
        }
    }
}

struct ActiveStreakCard: View {
    @Environment(\.colorScheme) var colorScheme
    let streak: Streak
    let onEnd: () -> Void
    let onRename: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacing) {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.spacingSmall) {
                    Text(streak.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                    
                    Text("Started: \(formatDate(streak.startDate))")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                    
                    if streak.unitsPerWeek > 0 && streak.costPerUnit > 0 {
                        Text("Saved: \(streak.formattedMoneySaved)")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AppTheme.spacingSmall) {
                    Text("\(streak.daysActive)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                    
                    Text("days")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                        .textCase(.uppercase)
                }
            }
            
            Divider()
                .background(AppTheme.secondaryTextColor(for: colorScheme).opacity(0.3))
            
            HStack(spacing: AppTheme.spacing) {
                Button(action: onRename) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Rename")
                    }
                    .font(.subheadline)
                    .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.spacingSmall)
                    .background(AppTheme.primaryColor(for: colorScheme).opacity(0.1))
                    .cornerRadius(AppTheme.cornerRadiusSmall)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onEnd) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("End Streak")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.spacingSmall)
                    .background(Color.red)
                    .cornerRadius(AppTheme.cornerRadiusSmall)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(AppTheme.spacing)
        .background(AppTheme.cardBackgroundColor(for: colorScheme))
        .cornerRadius(AppTheme.cornerRadius)
        .shadow(
            color: AppTheme.shadow(for: colorScheme).color,
            radius: AppTheme.shadow(for: colorScheme).radius,
            x: AppTheme.shadow(for: colorScheme).x,
            y: AppTheme.shadow(for: colorScheme).y
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    CurrentStreaksView(viewModel: StreaksViewModel())
}

