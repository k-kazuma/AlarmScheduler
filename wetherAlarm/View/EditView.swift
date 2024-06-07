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
    @State var repeats = false
    @State var weekDay: [Int] = []
        
    var alarm: Alarm
    
    init(alarm: Alarm) {
        self.alarm = alarm
        _date = State(initialValue: alarm.time)
        _sound = State(initialValue: alarm.sound)
        _weekDay = State(initialValue: alarm.weekDay)
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
                
                VStack{
                    NavigationLink(destination: soundView(pickSound: $sound)){
                        HStack{
                            Text("サウンド")
                            Spacer()
                            Text(sound)
                        }
                        .padding(10)
                        
                    }
                    
                    Rectangle()
                          .frame(height: 1)
                          .foregroundColor(backGroundBlack)
                          .opacity(0.8)
                    
                    NavigationLink(destination: WeekPickView(weeks: $weekDay)){
                        HStack{
                            Text("繰り返し")
                            Spacer()
                            
                            if weekDay.isEmpty {
                                Text("しない")
                                
                            }else if weekDay == [0,1,2,3,4,5,6] {
                                Text("毎日")
                            } else if weekDay == [1,2,3,4,5] {
                                Text("平日")
                            } else {
                                ForEach(weekDay, id: \.self) { week in
                                    switch week {
                                    case 0:
                                        Text("日")
                                    case 1:
                                        Text("月")
                                    case 2:
                                        Text("火")
                                    case 3:
                                        Text("水")
                                    case 4:
                                        Text("木")
                                    case 5:
                                        Text("金")
                                    case 6:
                                        Text("土")
                                    default:
                                        Text("?")
                                    }
                                }
                            }
                        }
                        .padding(10)
                    }
                }
                .frame(width: width*0.9)
                .foregroundColor(.white)
                .font(.system(size: 24))
                .background(backGroundGlay)
                .cornerRadius(10)
                
                Spacer()
                
                if alarm.isActive && !alarm.weekDay.isEmpty {
                    if alarm.skipDate == nil {
                        Button("スキップ"){
                            do{
                                try alarm.skipAlarm(id: alarm.id)
                                dismiss()
                            } catch{
                                print(error)
                            }
                        }
                        .buttonStyle(mainButtonStyle())
                    } else {
                        Button("スキップ解除"){
                            Task{
                                do {
                                    // 一度全て削除して再設置する
                                    //削除
                                    if alarm.weekDay.isEmpty {
                                        NotificationManager.instance.removeNotification(id: "\(alarm.id)")
                                    } else {
                                        for week in alarm.weekDay {
                                            NotificationManager.instance.removeNotification(id: "\(alarm.id)-\(week)")
                                        }
                                        for num in [7, 14, 21, 28] {
                                            NotificationManager.instance.removeNotification(id: "\(alarm.id)-skip\(num)")
                                        }
                                    }
                                    alarm.skipWeek = nil
                                    alarm.skipDate = nil
                                    
                                    //設置
                                    try await NotificationManager.instance.sendNotification(id: alarm.id, time: alarm.time, sound: alarm.sound, weekDay: alarm.weekDay)
                                    dismiss()
                                } catch {
                                    throw error
                                }
                            }
                        }
                        .buttonStyle(mainButtonStyle())
                    }
                }
                Button("保存する"){
                    print("【EditView:118】アラームを編集する処理")
                    Task{
                        do {
                            // SwiftDataとNotificationを更新
                            try await alarm.editAlarm(id: alarm.id, time: date, sound: sound, weekDay: weekDay)
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
                    print("【EditView:133】前のページに戻る処理")
                }
                .buttonStyle(mainButtonStyle())
                Spacer()
                    .frame(height: 1)
            }
        }.navigationBarBackButtonHidden(true)
    }
}
