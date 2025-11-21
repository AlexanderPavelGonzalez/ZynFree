//
//  AddStreakView.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct AddStreakView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = AddStreakViewModel()
    var hasCompletedOnboarding: Binding<Bool>?
    let onSave: ((Set<String>, Date, Int, Double) -> Void)?
    
    // Initializer for onboarding mode
    init(hasCompletedOnboarding: Binding<Bool>) {
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.onSave = nil
    }
    
    // Initializer for adding new streak mode
    init(onSave: @escaping (Set<String>, Date, Int, Double) -> Void) {
        self.hasCompletedOnboarding = nil
        self.onSave = onSave
    }
    
    private var isOnboarding: Bool {
        hasCompletedOnboarding != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
            VStack(spacing: AppTheme.spacingLarge) {
                // Header
                VStack(spacing: AppTheme.spacingSmall) {
                    QuitIcon(size: 100)
                        .padding(.bottom, AppTheme.spacingSmall)
                    
                    Text(viewModel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.subtitle)
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                }
                .padding(.top, AppTheme.spacingXLarge)
                .padding(.bottom, AppTheme.spacing)
                .onAppear {
                    viewModel.isOnboarding = isOnboarding
                }
                
                // Addiction Selection
                VStack(alignment: .leading, spacing: AppTheme.spacing) {
                    Text("What are you quitting?")
                        .font(.headline)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                    
                    ScrollView {
                        VStack(spacing: AppTheme.spacingSmall) {
                            ForEach(viewModel.availableAddictions, id: \.self) { addiction in
                                AddictionSelectionCard(
                                    addiction: addiction,
                                    isSelected: viewModel.selectedAddictions.contains(addiction)
                                ) {
                                    viewModel.toggleAddiction(addiction)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .cardStyle()
                
                // Quit Date
                VStack(alignment: .leading, spacing: AppTheme.spacing) {
                    DatePicker(
                        "Quit Date",
                        selection: $viewModel.quitDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .accentColor(AppTheme.primaryColor(for: colorScheme))
                }
                .cardStyle()
                
                // Units Input
                VStack(alignment: .leading, spacing: AppTheme.spacing) {
                    Text("How many units per week?")
                        .font(.headline)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                    
                    TextField("Enter number", text: $viewModel.unitsPerWeek)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(AppTheme.backgroundColor(for: colorScheme))
                        .cornerRadius(AppTheme.cornerRadiusSmall)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                }
                .cardStyle()
                
                // Cost Input
                VStack(alignment: .leading, spacing: AppTheme.spacing) {
                    Text("Cost per unit?")
                        .font(.headline)
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                    
                    HStack {
                        Text("$")
                            .font(.title3)
                            .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                        
                        TextField("0.00", text: $viewModel.costPerUnit)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(AppTheme.backgroundColor(for: colorScheme))
                            .cornerRadius(AppTheme.cornerRadiusSmall)
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                    }
                }
                .cardStyle()
                
                // Complete Button
                Button(action: {
                    let unitsPerWeek = Int(viewModel.unitsPerWeek) ?? 0
                    let costPerUnit = Double(viewModel.costPerUnit) ?? 0.0
                    
                    if isOnboarding {
                        viewModel.completeOnboarding()
                        hasCompletedOnboarding?.wrappedValue = true
                    } else {
                        onSave?(viewModel.selectedAddictions, viewModel.quitDate, unitsPerWeek, costPerUnit)
                        viewModel.reset()
                        dismiss()
                    }
                }) {
                    Text("Start Tracking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.canComplete ? AppTheme.primaryColor(for: colorScheme) : Color.gray)
                        .cornerRadius(AppTheme.cornerRadius)
                }
                .disabled(!viewModel.canComplete)
                .padding(.vertical, AppTheme.spacing)
                
                Spacer(minLength: AppTheme.spacingLarge)
            }
            .padding(AppTheme.spacing)
            }
            .background(AppTheme.backgroundColor(for: colorScheme))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if viewModel.showCancelButton {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cancel") {
                            viewModel.reset()
                            dismiss()
                        }
                        .foregroundColor(AppTheme.textColor(for: colorScheme))
                    }
                }
            }
        }
    }
}

struct AddictionSelectionCard: View {
    @Environment(\.colorScheme) var colorScheme
    let addiction: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(addiction)
                    .font(.body)
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? AppTheme.primaryColor(for: colorScheme) : AppTheme.secondaryTextColor(for: colorScheme))
                    .font(.title3)
            }
            .padding()
            .background(
                isSelected ?
                AppTheme.primaryColor(for: colorScheme).opacity(0.1) :
                AppTheme.backgroundColor(for: colorScheme)
            )
            .cornerRadius(AppTheme.cornerRadiusSmall)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall)
                    .stroke(
                        isSelected ? AppTheme.primaryColor(for: colorScheme) : Color.clear,
                        lineWidth: 2
                    )
            )
        }
    }
}

#Preview {
    AddStreakView(hasCompletedOnboarding: .constant(false))
}

