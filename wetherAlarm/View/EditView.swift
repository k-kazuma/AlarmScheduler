//
//  EditView.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/08.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State var date: Date
    @State var sound: String
    
    var alarm: Alarm
    
    init(alarm: Alarm) {
        self.alarm = alarm
        _date = State(initialValue: alarm.time)
        _sound = State(initialValue: alarm.sound)
    }
    
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
                
                Button("保存する"){
                    print("【AddAlarmView:29】アラームを編集する処理")
                    Task{
                        do {
                            // SwiftDataとNotificationを更新
                            try await alarm.editAlarm(id: alarm.id, time: date, sound: sound)
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
