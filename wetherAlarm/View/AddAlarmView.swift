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
    @State var sound = "24ctu"
    
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
                NavigationLink(destination: soundView(pickSound: $sound)){
                    Text("サウンド")
                    Spacer()
                    Text(sound)
                }
                .frame(width: width * 0.8)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .padding()
                .background(backGroundGlay)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                
                Spacer()
                
                Button("追加する"){
                    print("【AddAlarmView:29】アラームを追加する処理")
                    Task{
                        do{
                            // date型をIntのタプルへして返す
                            let (hour, minute) = await addAlarm(time: date)
                            // DataModelに値を渡す。
                            let alarm = try await Alarm(hour: hour, minute: minute, sound: sound)
                            context.insert(alarm)
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
                }
                .buttonStyle(mainButtonStyle())
                Spacer()
                    .frame(height: 1)
            }
        }.navigationBarBackButtonHidden(true)
    }
}
