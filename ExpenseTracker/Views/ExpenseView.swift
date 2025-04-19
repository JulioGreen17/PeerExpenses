//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 2/02/25.
//
import SwiftUI

struct ExpenseView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.dismiss) var dismiss
    @Environment(ExpenseManager.self) var expenseManager

    @State private var expenseName: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false

    private let categories = ["Food", "Transport", "Utilities", "Other"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Name", text: $expenseName)
                        .textInputAutocapitalization(.words)

                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveTapped()
                    }
                }
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    private func saveTapped() {
        guard !expenseName.isEmpty,
              !category.isEmpty,
              let amountDouble = Double(amount),
              amountDouble > 0 else {
            alertMessage = "Please fill all fields correctly."
            showingAlert = true
            return
        }

        Task {
            do {
                try await expenseManager.saveExpense(name: expenseName, amount: amountDouble, category: category)
                dismiss()
            } catch {
                alertMessage = "Error saving expense: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}
