//
//  wetherAlarmApp.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/03/28.
//

import SwiftUI
import SwiftData
import NotificationCenter

@main
struct wetherAlarmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            TopView()
                .modelContainer(for: Alarm.self)
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            debugPrint("application:didFinishLaunchingWithOptions:")
            NotificationManager.instance.requestPermission()
            UNUserNotificationCenter.current().delegate = self
            return true
        }
    }
}
