//
//  BudgetManager.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 4/19/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class BudgetManager {
    private let database = Firestore.firestore()
    var budget: Budget?

    func loadBudget(for userId: String) {
        database.collection("budgets")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading budget: \(error.localizedDescription)")
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("No budget found for user.")
                    return
                }

                do {
                    self.budget = try document.data(as: Budget.self)
                } catch {
                    print("Failed to decode budget: \(error.localizedDescription)")
                }
            }
    }

    func saveBudget(daily: Double, weekly: Double, monthly: Double) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }

        let budget = Budget(userId: uid, dailyLimit: daily, weeklyLimit: weekly, monthlyLimit: monthly)

        do {
            try await database.collection("budgets").document(uid).setData([
                "id": budget.id,
                "userId": budget.userId,
                "dailyLimit": budget.dailyLimit,
                "weeklyLimit": budget.weeklyLimit,
                "monthlyLimit": budget.monthlyLimit
            ])
            self.budget = budget
        } catch {
            throw error
        }
    }
}
