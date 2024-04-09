
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
}


