//
//  LocalNotificationManager.swift
//  NotificationsTest
//
//  Created by sopra on 24/11/20.
//  Copyright © 2020 ÁF. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

struct LocalNotification {
    var id: String
    var title: String
    var body: String
}

enum LocalNotificationDurationType {
    case days
    case hours
    case minutes
    case seconds
}

enum LocalNotificationManager {
    private static var notifications = [LocalNotification]()

    private static func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true, error == nil {
                    // We have permission!
                }
            }
    }

    private static func addNotification(title: String, body: String) {
        notifications.append(LocalNotification(id: UUID().uuidString, title: title, body: body))
    }

    private static func scheduleNotifications(_ durationInSeconds: Int, repeats: Bool, userInfo: [AnyHashable: Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
            content.userInfo = userInfo

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(durationInSeconds), repeats: repeats)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
        notifications.removeAll()
    }

    private static func scheduleNotifications(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, userInfo: [AnyHashable: Any]) {
        var seconds = 0
        switch type {
        case .seconds:
            seconds = duration
        case .minutes:
            seconds = duration * 60
        case .hours:
            seconds = duration * 60 * 60
        case .days:
            seconds = duration * 60 * 60 * 24
        }
        scheduleNotifications(seconds, repeats: repeats, userInfo: userInfo)
    }

    static func cancel() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    static func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String, userInfo: [AnyHashable: Any]) {
        requestPermission()
        addNotification(title: title, body: body)
        scheduleNotifications(duration, of: type, repeats: repeats, userInfo: userInfo)
    }
}
