//
//  UserView.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 3/17/25.
//

import SwiftUI

struct UserView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(BudgetManager.self) var budgetManager

    @State private var dailyLimit: String = ""
    @State private var weeklyLimit: String = ""
    @State private var monthlyLimit: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Budget Limits")) {
                    TextField("Daily Limit", text: $dailyLimit)
                        .keyboardType(.decimalPad)

                    TextField("Weekly Limit", text: $weeklyLimit)
                        .keyboardType(.decimalPad)

                    TextField("Monthly Limit", text: $monthlyLimit)
                        .keyboardType(.decimalPad)

                    Button("Save Budget") {
                        saveBudgetTapped()
                    }
                }

                Section {
                    Button("Log Out", role: .destructive) {
                        authManager.signOut()
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                if let budget = budgetManager.budget {
                    dailyLimit = String(format: "%.2f", budget.dailyLimit)
                    weeklyLimit = String(format: "%.2f", budget.weeklyLimit)
                    monthlyLimit = String(format: "%.2f", budget.monthlyLimit)
                }
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    private func saveBudgetTapped() {
        guard let daily = Double(dailyLimit),
              let weekly = Double(weeklyLimit),
              let monthly = Double(monthlyLimit) else {
            alertMessage = "Please enter valid numbers for all limits."
            showingAlert = true
            return
        }

        Task {
            do {
                try await budgetManager.saveBudget(daily: daily, weekly: weekly, monthly: monthly)
                alertMessage = "Budget saved successfully!"
                showingAlert = true
            } catch {
                alertMessage = "Failed to save budget: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}


#Preview {
    UserView()
        .environment(ExpenseManager(isMocked: true))
}
