//
//  wetherAlarmApp.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/03/28.
//

import SwiftUI
import SwiftData
import UserNotifications

let f = DateFormatter()

final class toggleTabBar: ObservableObject {
    @Published  var tabHidden: Bool = false
}

@main
struct AlarmSchedulerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var tabHidden = toggleTabBar()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Alarm.self,
            CalendarAlarm.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init(){
        AppEnvironment.sharedModelContainer = initializeModelContainer()
        f.dateStyle = .none
        f.timeStyle = .short
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environmentObject(tabHidden)
        }
    }
    
    private func initializeModelContainer() -> ModelContainer {
        let schema = Schema([
            Alarm.self,
            CalendarAlarm.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
    }
}
class AppEnvironment {
    static var sharedModelContainer: ModelContainer!
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, _) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }
        return true
    }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([[.banner, .list, .sound]])
        }
}
    

extension Date {
    init(hour: Int, minute: Int) {
        let calendar = Calendar.current
        let components = DateComponents(hour: hour, minute: minute)
        self = calendar.date(from: components)!
    }
}

extension Date {
    init(year: Int, month: Int, day: Int, hour: Int) {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day, hour: hour)
        self = calendar.date(from: components)!
    }
}

extension Date {
    init(year: Int, month: Int, day: Int) {
        let calendar = Calendar.current
        let now = Date()
        let currentComponents = calendar.dateComponents([.hour, .minute], from: now)
        let components = DateComponents(year: year, month: month, day: day, hour: currentComponents.hour, minute: currentComponents.minute)
        self = calendar.date(from: components)!
    }
}

//}
//
//
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        debugPrint("application:didFinishLaunchingWithOptions:")
//        NotificationManager.instance.requestPermission()
//        UNUserNotificationCenter.current().delegate = self
//        return true
//    }
//}
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(
//        _ center: UNUserNotificationCenter,
//        willPresent notification: UNNotification,
//        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//            completionHandler([[.banner, .list, .sound]])
//        }
//}
