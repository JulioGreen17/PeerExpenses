//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 2/10/25.
//

import Foundation

struct Expense: Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    var timestamp: Date = Date()
    let name: String
    let amount: Double
    let category: String
    let username: String
}

extension Expense {
    static let mockedExpenses: [Expense] = [
        Expense(name: "Rent", amount: 100, category: "Utilities", username: "test@gmail.com"),
        Expense(name: "Banh mi", amount: 7.5, category: "Food", username: "test@gmail.com"),
        Expense(name: "Bus fare", amount: 2.5, category: "Transport", username: "test@gmail.com"),
        Expense(name: "Gas money", amount: 10, category: "Transport", username: "test@gmail.com"),
        Expense(name: "Nest Indigo Perfume", amount: 92, category: "Other", username: "test@gmail.com"),
        Expense(name: "WiFi", amount: 25, category: "Utilities", username: "test@gmail.com"),
        Expense(name: "Netflix", amount: 17.99, category: "Entertainment", username: "test@gmail.com"),
        Expense(name: "Spotify", amount: 11.99, category: "Entertainment", username: "test@gmail.com"),
        Expense(name: "Pizza", amount: 18, category: "Food", username: "test@gmail.com"),
        Expense(name: "Levi's jeans", amount: 50, category: "Other", username: "test@gmail.com")
    ]
}
