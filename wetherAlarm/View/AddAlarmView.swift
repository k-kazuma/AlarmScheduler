//
//  AddAlarmView.swift
//  wetherAlarm
//testtest
//  Created by 熊谷知馬 on 2024/03/29.
//

import SwiftUI
import UserNotifications

struct AddAlarmView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @State var date = Date(year: 1999, month: 1, day: 1, hour: 7)
    @State var sound = "24ctu"
    @State var weekDay: [Int] = []
    
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
                
                Button("追加する"){
                    print("【AddAlarmView:29】アラームを追加する処理")
                    Task{
                        do{
                            // DataModelに値を渡す。
                            let alarm = try await Alarm(time: date, sound: sound, weekDay: weekDay)
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
