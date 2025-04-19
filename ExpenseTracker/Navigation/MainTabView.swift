//
//  MainTabView.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 3/15/25.
//
import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

struct MainTabView: View {
    @Environment(AuthManager.self) var authManager
    @State var expenseManager: ExpenseManager = ExpenseManager()
    @State private var showAddExpense = false
    @State private var selectedTab = 0
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showLogoutAlert = false

    private let tabBarHeight: CGFloat = 75

    var body: some View {
        ZStack(alignment: .bottom) {
            mainContent
            bottomTabBar
        }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            contentForSelectedTab
                .edgesIgnoringSafeArea(.top)

            Spacer()
                .frame(height: tabBarHeight)
                .opacity(0)
        }
        .background(Color("background"))
    }

    private var bottomTabBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<4) { index in
                    Button(action: {
                        selectedTab = index
                        if index == 1 {
                            showAddExpense.toggle()
                        }
                    }) {
                        VStack {
                            Image(systemName: iconForTab(index))
                                .font(.system(size: 24))
                            Text(labelForTab(index))
                                .font(.caption)
                        }
                        .padding(.top)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $showAddExpense) {
            ExpenseView()
                .environment(expenseManager)
        }
    }

    private var contentForSelectedTab: some View {
        switch selectedTab {
        case 0:
            return AnyView(HomeView()
                .environment(expenseManager))
        case 2:
            return AnyView(GraphView()
                .environment(expenseManager))
        case 3:
            return AnyView(UserView()
                .environment(authManager)
                .environment(expenseManager)
                .environment(\.showLogoutAlert, $showLogoutAlert))
        default:
            return AnyView(EmptyView())
        }
    }

    private func iconForTab(_ index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "plus.circle.fill"
        case 2: return "chart.bar.fill"
        case 3: return "person.crop.circle.fill"
        default: return ""
        }
    }

    private func labelForTab(_ index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Add"
        case 2: return "Graphs"
        case 3: return "User"
        default: return ""
        }
    }
}

#Preview {
    HomeView()
        .environment(AuthManager()) // No arguments!
        .environment(ExpenseManager(isMocked: true)) // This is fine if your ExpenseManager supports it
}
