//
//  NotificationService.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 14.06.2025.
//

import Foundation
import UserNotifications


final class NotificationService: NotificationServiceProtocol {
    
//    static let shared = NotificationService()
    
    func scheduleNotification(id: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ Error requesting permission: \(error)")
            } else {
                print(granted ? "✅ Notifications permission granted" : "❌ Notifications permission denied")
            }
        }
    }
}


protocol NotificationServiceProtocol {
    func scheduleNotification(id: String, title: String, body: String, date: Date)
    func removeNotification(id: String)
    func requestNotificationPermission()
}
