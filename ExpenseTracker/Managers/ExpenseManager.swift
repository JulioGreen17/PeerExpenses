//
//  ExpenseManager.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 2/10/25.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine
@Observable
class ExpenseManager {
    private let dataBase = Firestore.firestore()
    var expenses: [Expense] = []
    
    init(isMocked: Bool = false) {
        if isMocked {
            expenses = Expense.mockedExpenses
        } else {
            getExpenses()
        }
    }
    
    func clearExpenses() {
        dataBase.collection("expenses").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            for document in snapshot?.documents ?? [] {
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document \(document.documentID): \(error)")
                    } else {
                        print("Document \(document.documentID) successfully deleted!")
                    }
                }
            }
            
            self.expenses.removeAll()
        }
    }
    
    func getExpenses() {
        dataBase.collectionGroup("expenses").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            let expenses = documents.compactMap { document in
                do {
                    return try document.data(as: Expense.self)
                } catch {
                    print("Error decoding document into message: \(error)")
                    return nil
                }
            }
            
            self.expenses = expenses
        }
    }
    
    func saveExpense(name: String, amount: Double, category: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(
                domain: "AuthError",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "User not logged in"]
            )
        }

        let expenseID = UUID().uuidString
        let timestamp = Date()

        let expenseData: [String: Any] = [
            "id": expenseID,
            "timestamp": Timestamp(date: timestamp),
            "name": name,
            "amount": amount,
            "category": category,
            "username": uid
        ]

        do {
            try await dataBase.collection("expenses").document(expenseID).setData(expenseData)

            // Optional: also update local array to reflect new data instantly in UI
            let newExpense = Expense(
                id: expenseID,
                timestamp: timestamp,
                name: name,
                amount: amount,
                category: category,
                username: uid
            )
            expenses.append(newExpense)
        } catch {
            throw error
        }
    }

}
