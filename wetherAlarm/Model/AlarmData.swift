
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
    var skipWeek: Int?
    var skipDate: Date?
    
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
    
    func skipAlarm(id: UUID) throws {
        guard  id == self.id else {
            throw checkNotification.not("アラームが存在しません")
        }
        Task{
            var calendar = Calendar.current
            let today = Date()
            let todayWeekDay = calendar.component(.weekday, from: today)
            let (hour, minute) = await dateConversion(time: self.time)
            
            
            // todayWeekDayは１〜７の整数（日〜土）
            var i = todayWeekDay
            if todayWeekDay == 7 {
                i = 0
            }
            // 条件を満たすまでループ　次回通知予定アラームを検索、削除　スキップ中の処理
            while true {
                print(i)
                if let next = self.weekDay.firstIndex(of: i) {
                    // 何日後がスキップされた日なのかを取得
                    guard let nextWeekday = getNextWeekday(nextIndex: next, hour: hour, minute: minute) else {
                        return
                    }
                    
                    // 一致する曜日が見つかれば削除
                    print("削除-\(next)")
                    NotificationManager.instance.removeNotification(id: "\(self.id)-\(next)")
                    
                    // 翌週以降のアラームを日付指定で設置（一月分）waitEdit 曜日とスキップしたDateを渡して翌週以降の日付を取得する。
                    for i in [7, 14, 21, 28] {
                        do{
                            try await NotificationManager.instance.sendSkipNotification(id: self.id, time: nextWeekday, day: i, sound: self.sound)
                        } catch{
                          print(error)
                        }
                    }
                    // スキップしている曜日時間をSwiftDataで管理する
                    self.skipWeek = next
                    self.skipDate = nextWeekday
                    break
                } else{
                    if todayWeekDay == 6 {
                        i = 0
                    } else{
                        i += 1
                    }
                }
            }
        }
    }
}

enum checkNotification: Error {
    case not(String)
}


//曜日のIndexを受け取りスキップした日付を返す
func getNextWeekday(nextIndex: Int, hour: Int, minute: Int) -> Date? {
    // 今日の日付を取得
    let today = Date()
    
    // カレンダーを取得
    var calendar = Calendar.current
    
    // 今日の曜日を取得
    let todayWeekday = calendar.component(.weekday, from: today)
    
    // 今日から次の日曜日までの日数を計算
    let daysToAdd = nextIndex - todayWeekday + (todayWeekday < nextIndex ? 0 : 7)
    
    // 日数を加算して次の日曜日の日付を求める
    if let nextWeekday = calendar.date(byAdding: .day, value: daysToAdd, to: today) {
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: nextWeekday)
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents)
    } else {
        return nil
    }
}
