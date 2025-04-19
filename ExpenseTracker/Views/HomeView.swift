//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 2/22/25.
//
import Foundation
import SwiftUI

struct HomeView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(ExpenseManager.self) var expenseManager
    @Environment(BudgetManager.self) var budgetManager
    @AppStorage("isDarkMode") private var isDarkMode = false

    enum DateFilter: String, CaseIterable {
        case today = "Today"
        case week = "This Week"
        case month = "This Month"
    }

    @State private var dateFilter: DateFilter = .today
    @State private var selectedCategory: String? = nil
    @State private var isAscending: Bool = true

    var lastExpenseDate: Date? {
        expenseManager.expenses.sorted(by: { $0.timestamp > $1.timestamp }).first?.timestamp
    }

    var isInactiveFor3Days: Bool {
        guard let last = lastExpenseDate else { return true }
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        return last < threeDaysAgo
    }

    var categories: [String] {
        Array(Set(expenseManager.expenses.map { $0.category })).sorted()
    }

    var filteredExpenses: [Expense] {
        let filteredByDate: [Expense]
        switch dateFilter {
        case .today:
            let start = Calendar.current.startOfDay(for: Date())
            filteredByDate = expenseManager.expenses.filter { $0.timestamp >= start }
        case .week:
            let start = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
            filteredByDate = expenseManager.expenses.filter { $0.timestamp >= start }
        case .month:
            let start = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
            filteredByDate = expenseManager.expenses.filter { $0.timestamp >= start }
        }

        if let category = selectedCategory, !category.isEmpty {
            return filteredByDate.filter { $0.category == category }
        } else {
            return filteredByDate
        }
    }

    var dailyTotal: Double {
        let today = Calendar.current.startOfDay(for: Date())
        return expenseManager.expenses
            .filter { $0.timestamp >= today }
            .reduce(0) { $0 + $1.amount }
    }

    var weeklyTotal: Double {
        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        return expenseManager.expenses
            .filter { $0.timestamp >= startOfWeek }
            .reduce(0) { $0 + $1.amount }
    }

    var monthlyTotal: Double {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
        return expenseManager.expenses
            .filter { $0.timestamp >= startOfMonth }
            .reduce(0) { $0 + $1.amount }
    }

    var budgetExceededMessage: String? {
        guard let budget = budgetManager.budget else { return nil }
        if dailyTotal > budget.dailyLimit {
            return "Daily budget exceeded! (Spent $\(dailyTotal), Limit $\(budget.dailyLimit))"
        } else if weeklyTotal > budget.weeklyLimit {
            return "Weekly budget exceeded! (Spent $\(weeklyTotal), Limit $\(budget.weeklyLimit))"
        } else if monthlyTotal > budget.monthlyLimit {
            return "Monthly budget exceeded! (Spent $\(monthlyTotal), Limit $\(budget.monthlyLimit))"
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 0) {
            if isInactiveFor3Days {
                Text("You haven’t logged expenses in over 3 days!")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding([.horizontal, .top])
            }

            if let message = budgetExceededMessage {
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding([.horizontal, .top])
            }

            HStack {
                Picker("Filter", selection: $dateFilter) {
                    ForEach(DateFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                Menu("Category") {
                    Button("All") {
                        selectedCategory = nil
                    }
                    ForEach(categories, id: \.self) { category in
                        Button(category) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)

            List {
                ForEach(filteredExpenses) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.headline)
                            Text(expense.category)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(String(format: "$%.2f", expense.amount))
                    }
                }
            }
            .background(Color("background"))
        }
        .onAppear {
            NotificationManager.shared.scheduleInactivityReminderIfNeeded(expenses: expenseManager.expenses)
        }
    }
}


#Preview {
    HomeView()
        .environment(AuthManager()) // No arguments!
        .environment(ExpenseManager(isMocked: true)) // This is fine if your ExpenseManager supports it
}
