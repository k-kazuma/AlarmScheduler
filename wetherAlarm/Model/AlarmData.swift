
import Foundation
import SwiftData
import UserNotifications

@Model
final class Alarm {
    var id: UUID
    var time: Date
    var sound: String
    var weekDay: [Int]
    var isActive: Bool
    
    init(id: UUID = UUID(), time: Date, sound: String, weekDay: [Int]) async throws {
        try await NotificationManager.instance.sendNotification(id: id, time: time, sound: sound, weekDay: weekDay)
        
        self.id = id
        self.time = time
        self.sound = sound
        self.weekDay = weekDay
        self.isActive = true
    }
    
    func editAlarm(id: UUID, time: Date, sound: String, weekDay: [Int]) async throws {
        self.time = time
        self.sound = sound
        self.weekDay = weekDay
        self.isActive = true
        let difference = self.weekDay.filter{!weekDay.contains($0)}
        for dif in difference {
            NotificationManager.instance.removeNotification(id: "\(self.id)-\(dif)")
        }
        try await NotificationManager.instance.sendNotification(id: id, time: time, sound: sound, weekDay: weekDay)
    }
    
    func deleteAlarm(id: UUID) throws {
        guard  id == self.id else {
            throw checkNotification.not("アラームが存在しません")
        }
        // 起動中であれば削除
        if self.isActive == true {
            if self.weekDay.isEmpty {
                NotificationManager.instance.removeNotification(id: "\(self.id)")
            } else {
                for week in self.weekDay {
                    NotificationManager.instance.removeNotification(id: "\(self.id)-\(week)")
                }
            }
        }
        self.modelContext?.delete(self)
    }
    
    func toggleAlarm(id: UUID) throws {
        guard id == self.id else {
            throw checkNotification.not("アラームが存在しません")
        }
        if self.isActive == true {
            Task{
                do{
                    print("アラーム設置")
                    try await NotificationManager.instance.sendNotification(id: self.id, time: self.time, sound: self.sound, weekDay: self.weekDay)
                } catch {
                    throw error
                }
            }
        } else {
            print("アラーム削除")
            if self.weekDay.isEmpty {
                NotificationManager.instance.removeNotification(id: "\(self.id)")
            } else {
                for week in self.weekDay {
                    NotificationManager.instance.removeNotification(id: "\(self.id)-\(week)")
                }
            }
        }
    }
}

enum checkNotification: Error {
    case not(String)
}
