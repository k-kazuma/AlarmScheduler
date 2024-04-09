//
//  AddAlarmView.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/03/29.
//

import SwiftUI
import UserNotifications

struct AddAlarmView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @State var date = Date()
    
    var body: some View {
        ZStack{
            backGroundBlack
                .edgesIgnoringSafeArea(.all)
            VStack{
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .colorInvert()
                    .colorMultiply(.white)
                    .padding(.top, 100)
                
                Spacer()
                
                Button("追加する"){
                    print("【AddAlarmView:29】アラームを追加する処理")
                    Task{
                        
                        do{
                            // date型をIntのタプルへして返す
                            let res = await addAlarm(time: date)
                            // SwiftDataとUserNotificationの共有する一意の値
                            let id = UUID()
                            // SwiftDataにアラームを保存
                            let alarm = Alarm(id: id, hour: res.0, minute: res.1)
                            context.insert(alarm)
                            // UserNotificationへアラームを設置
                            try await NotificationManager.instance.sendNotification(id: id, hour: res.0, minute: res.1)
                            // 前の画面に戻る
                            dismiss()
                        }catch {
                            print(error)
                        }
                    }
                }
                .buttonStyle(mainButtonStyle())
                Button("キャンセル"){
                    dismiss()
                    print("【AddAlarmView:35】前のページに戻る処理")
                }
                .buttonStyle(mainButtonStyle())
                Spacer()
                    .frame(height: 1)
            }
        }.navigationBarBackButtonHidden(true)
    }
}
