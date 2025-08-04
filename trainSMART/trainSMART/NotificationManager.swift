import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ Error requesting notifications: \(error.localizedDescription)")
            } else {
                print("✅ Notification permission granted: \(granted)")
            }
        }
    }

    func scheduleDailyNotification(at hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to train!"
        content.body = "You have to fight to reach your dream. You have to sacrifice and work hard. – Cristiano Ronaldo"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyTrainingReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Daily notification scheduled at \(hour):\(minute)")
            }
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("⏰ Pending notifications: \(requests.count)")
            for req in requests {
                print("🔔 ID: \(req.identifier)")
            }
        }

    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🔕 All notifications canceled")
    }
}
