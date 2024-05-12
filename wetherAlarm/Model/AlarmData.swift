
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
        print("AlarmInit")
        Task{
            do{
                try await NotificationManager.instance.sendNotification(id: id, time: time, sound: sound, weekDay: weekDay)
            } catch{
                throw error
            }
        }
        self.id = id
        self.time = time
        self.sound = sound
        self.weekDay = weekDay
        self.isActive = true
    }
    
    func editAlarm(id: UUID, time: Date, sound: String, weekDay: [Int]) async throws {
        Task{
            do{
                try await NotificationManager.instance.sendNotification(id: id, time: time, sound: sound, weekDay: weekDay)
                self.time = time
                self.sound = sound
                self.weekDay = weekDay
            }catch {
                throw error
            }
        }
    }
    
    func deleteAlarm(id: UUID) throws {
        guard  id == self.id else {
            throw checkNotification.not("アラームが存在しません")
        }
        NotificationManager.instance.removeNotification(id: "\(self.id)")
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
