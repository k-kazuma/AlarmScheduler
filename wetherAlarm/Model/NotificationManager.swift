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
    
    func sendNotification(id:UUID , time:Date, sound: String, repeats: Bool) async throws {
        
        do{
            let content = UNMutableNotificationContent()
            content.title = "Notification Title"
            content.body = "Local Notification Test"
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: sound + ".mp3"))
            
            var dateComponents = DateComponents()
            let (hour, minute) = await dateConversion(time: time)
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
            let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            throw error
        }
    }
    
    func removeNotification(id:String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func getPendingNotifications() async -> [String] {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let pendingIdentifiers = requests.map { $0.identifier }
                continuation.resume(returning: pendingIdentifiers)
            }
        }
    }
}
