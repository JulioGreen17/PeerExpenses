//
//  NotificationManager.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 4/3/25.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    func scheduleInactivityReminderIfNeeded(expenses: [Expense]) {
        guard let latest = expenses.sorted(by: { $0.timestamp > $1.timestamp }).first else {
            scheduleNotification()
            return
        }

        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        if latest.timestamp < threeDaysAgo {
            scheduleNotification()
        }
    }

    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Don't forget to log expenses!"
        content.body = "You haven’t logged any expenses in a while — check your spending."
        content.sound = .default

        // You can adjust the timeInterval as needed. 5 seconds is just for demo.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(
            identifier: "inactivityReminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
