//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by 熊谷知馬 on 2024/05/17.
//

import UIKit
import SwiftUI
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    //    @IBOutlet var label: UILabel?
    
    var content: UNNotificationContent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        displayNotificationView()
    }
    
    func displayNotificationView() {
        
        if let content = content {
            // NotificationViewのインスタンスを作成
            let notificationView = NotificationView(content: content)
            
            let hostingController = UIHostingController(rootView: notificationView)
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.view.frame = view.bounds
            hostingController.didMove(toParent: self)
        }
    }
    
    func didReceive(_ notification: UNNotification) {
        content = notification.request.content
    }
    
}


struct NotificationView: View {
    
    var content: UNNotificationContent
    
    init(content: UNNotificationContent){
        self.content = content
    }
    
    var body: some View{
        VStack{
            Text(content.title)
            Button("wakeUp"){
                print("wakeUp")
            }
            Button("sleep"){
                print("sleep")
            }
            
        }
    }
}
