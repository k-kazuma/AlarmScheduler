
import Foundation
import SwiftData
import UserNotifications

@Model
final class Alarm {
    var id: UUID
    var hour: Int
    var minute: Int
    var isActive: Bool
    
    init(id: UUID, hour: Int, minute: Int) {
        self.id = id
        self.hour = hour
        self.minute = minute
        self.isActive = true
    }
    
    func editAlarm(id: UUID, hour: Int, minute: Int) async throws {
        Task{
            do{
                try await NotificationManager.instance.sendNotification(id: id, hour: hour, minute: minute)
                self.hour = hour
                self.minute = minute
            }catch {
                throw error
            }
        }
    }
    
    func deleteAlarm() {
        NotificationManager.instance.removeNotification(id: "\(self.id)")
        self.modelContext?.delete(self)
    }
}


