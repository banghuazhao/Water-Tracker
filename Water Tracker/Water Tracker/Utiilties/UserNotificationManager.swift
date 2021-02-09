//
//  UserNotificationManager.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 2021/2/1.
//

import UserNotifications

class UserNotificationManager {
    static let shared = UserNotificationManager()

    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }

    func schedule(id: UUID, title: String, subTitle: String?, body: String?, badges: Int?, isRepeat: Bool = true, dateComponents: DateComponents) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if granted == true && error == nil {
                        self.scheduleNotification(id: id, title: title, subTitle: subTitle, body: body, badges: badges, isRepeat: isRepeat, dateComponents: dateComponents)
                    }
                }
            case .authorized, .provisional:
                self.scheduleNotification(id: id, title: title, subTitle: subTitle, body: body, badges: badges, isRepeat: isRepeat, dateComponents: dateComponents)
            default:
                break // Do nothing
            }
        }
    }

    private func scheduleNotification(id: UUID, title: String, subTitle: String?, body: String?, badges: Int?, isRepeat: Bool = true, dateComponents: DateComponents) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = title
        if let subTitle = subTitle {
            content.subtitle = subTitle
        }
        if let body = body {
            content.body = body
        }
        if let badges = badges {
            content.badge = NSNumber(value: badges)
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isRepeat)

        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in

            guard error == nil else { return }

            print("Notification scheduled! --- ID = \(id)")
        }
    }

    func remove(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
}


class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    // 在应用内展示通知
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])

        // 如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
        // completionHandler([])
    }
}
