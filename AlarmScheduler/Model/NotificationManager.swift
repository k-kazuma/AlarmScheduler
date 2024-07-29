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
    var calendar = Calendar.current
    
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { (granted, _) in
                print("(../Model/NotificationManager.swift:18)Permission granted: \(granted)")
            }
    }
    
    func sendNotification(id:UUID , time:Date, sound: String, weekDay: [Int]) async throws {
        
        do{
            let content = UNMutableNotificationContent()
            content.title = "アラーム"
            content.body = "おはようございます"
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: sound + ".mp3"))
            
            if !weekDay.isEmpty {
                for week in weekDay{
                    var dateComponents = DateComponents()
                    let (hour, minute) = dateConversion(time: time)
                    dateComponents.weekday = week
                    dateComponents.hour = hour
                    dateComponents.minute = minute
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: "\(id)-\(week)", content: content, trigger: trigger)
                    try await UNUserNotificationCenter.current().add(request)
                }
            } else {
                var dateComponents = DateComponents()
                let (hour, minute) = dateConversion(time: time)
                dateComponents.hour = hour
                dateComponents.minute = minute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
                try await UNUserNotificationCenter.current().add(request)
            }
        } catch {
            throw error
        }
    }
    
    //スキップした日の翌週以降のアラームを設置　waitEdit
    func sendSkipNotification(id:UUID , time:Date, day:Int, sound: String) async throws {
        let content = UNMutableNotificationContent()
        content.title = "アラーム"
        content.body = "おはようございます"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: sound + ".mp3"))
        let dateComponents = calendar.date(byAdding: .day, value: day, to: time)!
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateComponents), repeats: false)
        let request = UNNotificationRequest(identifier: "\(id)-skip\(day)", content: content, trigger: trigger)
        print("try add")
        try await UNUserNotificationCenter.current().add(request)
        print("end add")
        
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
    
    func sendCalendarNotification(id: UUID, year: Int, month: Int, day: Int, time: Date, sound: String) throws {
        let (hour, minute) = dateConversion(time: time)
        let content = UNMutableNotificationContent()
        var date = DateComponents()
        date.year = year
        date.month = month
        date.day = day
        date.hour = hour
        date.minute = minute
        
        content.title = "アラーム"
        content.body = "おはようございます"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: sound + ".mp3"))
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: "calendar-\(id)", content: content, trigger: trigger)
        
        Task{
            do {
                print("try add")
                try await UNUserNotificationCenter.current().add(request)
                print(await getPendingNotifications())
                print("end add")
            } catch {
                print("NotificationError",error)
            }
        }
    }
}
