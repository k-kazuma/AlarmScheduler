//
//  CalendarAddView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/27.
//

import SwiftUI

struct CalendarAddTimeView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    var year: Int
    var month: Int
    var days: [Int]
    
    @State var date = Date(year: 1999, month: 1, day: 1, hour: 7)
    @State var sound = MusicPlayer().soundList[0]
    @Binding var comp: Bool
    
    init(year: Int, month: Int, days: [Int], comp: Binding<Bool>){
        self.year = year
        self.month = month
        self.days = days
        self._comp = comp
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
                }
                .frame(width: width*0.9)
                .foregroundColor(.white)
                .font(.system(size: 24))
                .background(backGroundGlay)
                .cornerRadius(10)
                Spacer()
                
                Button("追加する") {
                    do {
                        for day in days {
                            let id = UUID()
                            let alarm =  CalendarAlarm(id: id, year: year, month: month, day: day, time: date, sound: sound)
                            context.insert(alarm)
                            try NotificationManager.instance.sendCalendarNotification(id: id, year: year, month: month, day: day, time: date, sound: sound)
                        }
                    } catch{
                        print(error)
                    }
                    comp = true
                    dismiss()
                }
                .buttonStyle(mainButtonStyle())
                Button("キャンセル"){
                    dismiss()
                }
                .buttonStyle(mainButtonStyle())
                Spacer()
                    .frame(height: 1)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    CalendarAddTimeView(year: 1, month: 1, days: [1])
//}
