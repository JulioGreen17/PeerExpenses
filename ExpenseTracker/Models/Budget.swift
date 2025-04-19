//
//  Budget.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 4/19/25.
//

import Foundation

struct Budget: Identifiable, Codable {
    var id: String = UUID().uuidString
    var userId: String
    var dailyLimit: Double
    var weeklyLimit: Double
    var monthlyLimit: Double
}
