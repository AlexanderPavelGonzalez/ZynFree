//
//  HistoryView.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var viewModel: StreaksViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundColor(for: colorScheme)
                    .ignoresSafeArea()
                
                if viewModel.completedStreaks.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: AppTheme.spacing) {
                            ForEach(viewModel.completedStreaks) { streak in
                                NavigationLink(destination: StreakDetailView(streak: streak, viewModel: viewModel)) {
                                    CompletedStreakCard(streak: streak)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(AppTheme.spacing)
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadStreaks()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.spacingLarge) {
            QuitIcon(size: 100)
                .padding(.bottom, AppTheme.spacingSmall)
            
            Text("No History")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.textColor(for: colorScheme))
            
            Text("Completed streaks will appear here")
                .font(.body)
                .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.spacingLarge)
        }
    }
}

struct CompletedStreakCard: View {
    @Environment(\.colorScheme) var colorScheme
    let streak: Streak
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacing) {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.spacingSmall) {
                    Text(streak.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                    
                    if let endDate = streak.endDate {
                        Text("\(formatDate(streak.startDate)) → \(formatDate(endDate))")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                    }
                    
                    if streak.unitsPerWeek > 0 && streak.costPerUnit > 0 {
                        Text("Saved: \(streak.formattedMoneySaved)")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AppTheme.spacingSmall) {
                    Text("\(streak.totalDaysDuration)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                    
                    Text("days")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                        .textCase(.uppercase)
                }
            }
        }
        .padding(AppTheme.spacing)
        .background(AppTheme.cardBackgroundColor(for: colorScheme))
        .cornerRadius(AppTheme.cornerRadius)
        .shadow(
            color: AppTheme.shadow(for: colorScheme).color.opacity(0.3),
            radius: AppTheme.shadow(for: colorScheme).radius * 0.7,
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
    HistoryView(viewModel: StreaksViewModel())
}

