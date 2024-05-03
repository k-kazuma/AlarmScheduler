
import Foundation
import SwiftData
import UserNotifications

@Model
final class Alarm {
    var id: UUID
    var time: Date
    var sound: String
    var isActive: Bool
    
    init(id: UUID = UUID(), time: Date, sound: String, repeats: Bool) async throws {
        print("AlarmInit")
        Task{
            do{
                try await NotificationManager.instance.sendNotification(id: id, time: time, sound: sound, repeats: repeats)
            } catch{
                throw error
            }
        }
        self.id = id
        self.time = time
        self.sound = sound
        self.isActive = true
    }
    
    func editAlarm(id: UUID, time: Date, sound: String, repeats: Bool) async throws {
        Task{
            do{
                try await NotificationManager.instance.sendNotification(id: id, time: time, sound: sound, repeats: repeats)
                self.time = time
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
