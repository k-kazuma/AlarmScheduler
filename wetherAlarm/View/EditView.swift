//
//  EditView.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/08.
//

import SwiftUI

extension Date {
    init(hour: Int, minute: Int) {
        let calendar = Calendar.current
        let components = DateComponents(hour: hour, minute: minute)
        self = calendar.date(from: components)!
    }
}

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State var date = Date()
    @State var Uid = UUID()
    
    var alarm: Alarm
    
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
                    .onAppear(){
                        date = Date(hour: alarm.hour, minute: alarm.minute)
                    }
                
                Spacer()
                
                Button("保存する"){
                    print("【AddAlarmView:29】アラームを編集する処理")
                    Task{
                        do {
                            // date型をIntのタプルへして返す
                            let res = await addAlarm(time: date)
                            // SwiftDataを更新
                            alarm.hour = res.0
                            alarm.minute = res.1
                            // アラームを更新
                            try await NotificationManager.instance.sendNotification(id: alarm.id, hour: res.0, minute: res.1)
                            // 前の画面に戻る
                            dismiss()
                        } catch {
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
