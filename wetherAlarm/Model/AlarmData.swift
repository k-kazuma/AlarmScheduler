
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
    var skipData: [Int : Date]?
    
    init(id: UUID = UUID(), time: Date, sound: String, weekDay: [Int]) async throws {
        try await NotificationManager.instance.sendNotification(id: id, time: time, sound: sound, weekDay: weekDay)
        
        self.id = id
        self.time = time
        self.sound = sound
        self.weekDay = weekDay
        self.isActive = true
        self.skipData = nil
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
    
    func skipAlarm(id: UUID, weekDay: Int) throws {
        guard  id == self.id else {
            throw checkNotification.not("アラームが存在しません")
        }
        // weekDayは１〜７の整数（日〜土）
        var i = weekDay
        if weekDay == 7 {
            i = 0
        }
        // 条件を満たすまでループ
        while true {
            if let next = self.weekDay.firstIndex(of: i) {
                // 一致する曜日が見つかれば削除
                print("削除-\(next)")
                NotificationManager.instance.removeNotification(id: "\(self.id)-\(next)")
                // スキップしている曜日時間をSwiftDataで管理する
                self.skipData = [next: self.time]
                break
            }else{
                if weekDay == 6 {
                    i = 0
                } else{
                    i += 1
                }
            }
        }
    }
}

enum checkNotification: Error {
    case not(String)
}
