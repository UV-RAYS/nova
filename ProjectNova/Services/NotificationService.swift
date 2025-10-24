import Foundation
import UserNotifications

/// Service for handling local notifications
class NotificationService: ObservableObject {
    
    /// Request notification permissions
    func requestPermissions() async -> Bool {
        do {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            let (success, error) = await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
            
            if let error = error {
                print("Notification authorization error: \(error)")
                return false
            }
            
            return success
        } catch {
            print("Notification authorization failed: \(error)")
            return false
        }
    }
    
    /// Schedule a nightly report notification
    func scheduleNightlyReportNotification(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Your Daily Report is Ready"
        content.body = "Check your progress and insights for today"
        content.sound = .default
        content.badge = 1
        
        // Create date components for the trigger
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "nightly-report",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Nightly report notification scheduled for \(hour):\(minute)")
            }
        }
    }
    
    /// Send a notification
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }
}