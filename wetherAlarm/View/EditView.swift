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
                
                Button("スキップ"){
                    print("【EditView:104】次回アラームをスキップ")
                    
                    let cal = Calendar.current
                    let now = Date()
                    if let nowWeekDay = cal.dateComponents([.weekday], from: now).weekday {
                        print(nowWeekDay)
                    }
                    
                    
                }
                .buttonStyle(mainButtonStyle())
                
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
