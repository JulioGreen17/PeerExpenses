//
//  ShowLogoutAlertKey.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 4/19/25.
//


import SwiftUI

private struct ShowLogoutAlertKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var showLogoutAlert: Binding<Bool> {
        get { self[ShowLogoutAlertKey.self] }
        set { self[ShowLogoutAlertKey.self] = newValue }
    }
}
