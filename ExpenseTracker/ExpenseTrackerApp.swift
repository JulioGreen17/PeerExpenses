//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 3/20/25.
//

import SwiftUI
import FirebaseCore

@main
struct ExpenseTrackerApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    @State private var authManager: AuthManager
    @State private var expenseManager: ExpenseManager
    @State private var budgetManager: BudgetManager

    @State private var showMainView = false

    init() {
        FirebaseApp.configure()
        NotificationManager.shared.requestAuthorization()

        // ✅ Now safe: Firebase is configured before using Firestore
        self._authManager = State(wrappedValue: AuthManager())
        self._expenseManager = State(wrappedValue: ExpenseManager())
        self._budgetManager = State(wrappedValue: BudgetManager())
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showMainView {
                    if authManager.user != nil {
                        MainTabView()
                            .environment(authManager)
                            .environment(expenseManager)
                            .environment(budgetManager)
                    } else {
                        LoginView()
                            .environment(authManager)
                    }
                } else {
                    ContentView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    showMainView = true
                                }
                            }
                        }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

