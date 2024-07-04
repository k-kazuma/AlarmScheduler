//
//  CalenderView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/20.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    
    @Environment(\.modelContext) private var context
    @Query() private var calendarAlarts: [CalendarAlarm]

    @State var days:[calenderDay]
    @State var calenderDate: Date
    @State var year: Int
    @State var month: Int
    @State var monthShiftNum: Int = 0
    
    @State var alarms: [String] = []
    
    init(){
        //今月のカレンダー取得
        calenderDate = calendar.date(byAdding: .month, value: 0, to: Date())!
        year = calendar.component(.year, from: Date())
        month = calendar.component(.month, from: Date())
        days = generateDays(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()))
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                backGroundBlack
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack{
                        if calendar.date(byAdding: .month, value: 0, to: Date())! < calenderDate {
                            Button("<<") {
                                monthShiftNum -= 1
                            }
                        }
                        Text("\(String(year))年\(month)月")
                            .font(.largeTitle)
                            .padding()
                        Button(">>"){
                            monthShiftNum += 1
                        }
                    }
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                        Text("日")
                        Text("月")
                        Text("火")
                        Text("水")
                        Text("木")
                        Text("金")
                        Text("土")
                        ForEach(1..<42, id: \.self) { index in
                            
                            if index >= days[0].weekday && index - days[0].weekday < days.count {
                                // UIに表示されている情報
                                let nowDate = calendar.dateComponents([.year, .month, .day], from: Date())
                                let calendarDate = DateComponents(year: year, month: month, day: index + 1 - days[0].weekday )
                                if nowDate.year! >= calendarDate.year! && nowDate.month! >= calendarDate.month! && nowDate.day! > calendarDate.day! {
                                    VStack{
                                        Text("\(days[index - days[0].weekday].day)")
                                            .foregroundColor(backGroundGlay)
                                        Spacer()
                                    }
                                } else {
                                    ZStack{
                                        VStack{
                                            Text("\(days[index - days[0].weekday].day)")
                                            let newArray = calendarAlarts.filter { $0.year == year && $0.month == month && $0.day == days[index - days[0].weekday].day}
                                            if !newArray.isEmpty{
                                                Text("\(newArray[0].time)")
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            } else {
                                Spacer()
                                    .frame(height: 60)
                            }
                        }
                        .frame(height: 60)
                    }
                    ZStack{
                        
                        Button(action: {}){
                            NavigationLink(destination: CalendarAddView()){
                                Text("追加")
                            }
                        }
                        .buttonStyle(mainButtonStyle())
                    }
                }
                .onChange(of: monthShiftNum){
                    calenderDate = calendar.date(byAdding: .month, value: monthShiftNum, to: Date())!
                    year = calendar.component(.year, from: calenderDate)
                    month = calendar.component(.month, from: calenderDate)
                    days = generateDays(year: year, month: month)
                }
            }
            .foregroundColor(.white)
            .onAppear(){
                Task{
                    alarms = await seachAlarm()
                }
            }
        }
    }
    
    func seachAlarm() async -> [String] {
        let res = await NotificationManager.instance.getPendingNotifications()
        let newArray = res.filter{$0.contains("calendar")}
        print("設定済みアラーム", newArray)
        return newArray
    }
}

//#Preview{
//    CalendarView()
//}
