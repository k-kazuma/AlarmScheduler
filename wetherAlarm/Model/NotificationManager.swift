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
    
    public func notification() async {
        do {
            let content = UNMutableNotificationContent()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            //通知内容
            content.title = "ここは通知タイトル部分に表示されるよ"
            content.body = "ここは通知の説明部分に表示されるよ"
            content.sound = UNNotificationSound.default
            content.badge = 1
            //通知リクエストを作成
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print(error)
        }
    }
    
    func sendNotification(id:UUID ,hour: Int, minute: Int) async {
        
        print(id,hour,minute)
        
        do{
            let content = UNMutableNotificationContent()
            content.title = "Notification Title"
            content.body = "Local Notification Test"
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print(error)
        }
    }
}
