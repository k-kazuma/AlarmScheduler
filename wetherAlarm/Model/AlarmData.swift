
import Foundation
import SwiftData
import UserNotifications

@Model
final class Alarm {
    var id: UUID
    var hour: Int
    var minute: Int
    var sound: String
    var isActive: Bool
    
    init(id: UUID = UUID(), hour: Int, minute: Int, sound: String) async throws {
        print("AlarmInit")
        Task{
            do{
                try await NotificationManager.instance.sendNotification(id: id, hour: hour, minute: minute, sound: sound)
            } catch{
                throw error
            }
        }
        self.id = id
        self.hour = hour
        self.minute = minute
        self.sound = sound
        self.isActive = true
    }
    
    func editAlarm(id: UUID, hour: Int, minute: Int, sound: String) async throws {
        Task{
            do{
                try await NotificationManager.instance.sendNotification(id: id, hour: hour, minute: minute, sound: sound)
                self.hour = hour
                self.minute = minute
                self.sound = sound
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
}

enum checkNotification: Error {
    case not(String)
}
