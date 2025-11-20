//
//  SettingsView.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.spacingLarge) {
                    // Header
                    VStack(spacing: AppTheme.spacingSmall) {
                        QuitIcon(size: 70)
                            .padding(.bottom, AppTheme.spacingSmall)
                        
                        Text("Settings")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                        
                        Text("Update your tracking information")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.secondaryTextColor(for: colorScheme))
                    }
                    .padding(.top, AppTheme.spacing)
                    .padding(.bottom, AppTheme.spacingSmall)
                    
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
                        Text("When did you quit?")
                            .font(.headline)
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                        
                        DatePicker(
                            "Quit Date",
                            selection: $viewModel.quitDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .accentColor(AppTheme.primaryColor(for: colorScheme))
                        .onChange(of: viewModel.quitDate) { oldValue, newValue in
                            viewModel.updateQuitDate(newValue)
                        }
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
                            .onChange(of: viewModel.unitsPerWeek) { oldValue, newValue in
                                viewModel.updateUnitsPerWeek(newValue)
                            }
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
                                .onChange(of: viewModel.costPerUnit) { oldValue, newValue in
                                    viewModel.updateCostPerUnit(newValue)
                                }
                        }
                    }
                    .cardStyle()
                    
                    Spacer(minLength: AppTheme.spacingLarge)
                }
                .padding(AppTheme.spacing)
            }
            .background(AppTheme.backgroundColor(for: colorScheme))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryColor(for: colorScheme))
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}

