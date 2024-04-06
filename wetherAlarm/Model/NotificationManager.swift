//
//  Notifications.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/02.
//

import Foundation
import UserNotifications


final class NotificationManager {
    static let instance: NotificationManager = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { (granted, _) in
                print("(../Model/NotificationManager.swift:18)Permission granted: \(granted)")
            }
    }
    
    func sendNotification(id:UUID ,hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Local Notification Test"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
