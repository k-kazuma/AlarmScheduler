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
    @EnvironmentObject var tabHidden: toggleTabBar
    
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
                    
                    // 開発用ボタン
//                    Button("reset") {
//                        Task{
//                            let res = await NotificationManager.instance.getPendingNotifications()
//                            for r in res {
//                                NotificationManager.instance.removeNotification(id: r)
//                            }
//                            let alarmes = calendarAlarts.map {$0.id}
//                            for a in alarmes {
//                                print(calendarAlarts.first(where: {$0.id == a})!)
//                                context.delete(calendarAlarts.first(where: {$0.id == a})!)
//                            }
//                        }
//                    }
                    Spacer()
                    
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
                    Spacer()
                    // カレンダーUI
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                        Text("日")
                        Text("月")
                        Text("火")
                        Text("水")
                        Text("木")
                        Text("金")
                        Text("土")
                        // 月によってレイアウトが崩れないよう　７x６　で作成
                        ForEach(1..<42, id: \.self) { index in
                            // １日の開始位置を調整するために曜日のインデックス分空欄を作る。
                            if index >= days[0].weekday && index - days[0].weekday < days.count {
                                // UIに表示されている情報
                                let nowDate = calendar.dateComponents([.year, .month, .day], from: Date())
                                let calendarDate = DateComponents(year: year, month: month, day: index + 1 - days[0].weekday )
                                // 過去日がどうかで条件分岐
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
                                                    Text(f.string(from: newArray[0].time ))
                                            } else {
                                                Text("--")
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
                        .frame(height: 70)
                    }
                    
                    HStack{
                        Spacer()
                            .frame(width: 25)
                        Button(action: {
                        }) {
                            NavigationLink(destination: CalendarTrashView()){
                                Image(systemName: "trash")
                            }
                        }
                        .bold()
                        .frame(width: 75, height: 75)
                        .font(.system(size: 35))
                        .foregroundColor(fontOrenge)
                        .background(backGroundGlay)
                        .clipShape(Circle())
                        .buttonStyle(.plain)
                        .disabled(calendarAlarts.isEmpty)
                        Spacer()
                        Button(action: {
                        }) {
                            NavigationLink(destination: CalendarAddView()){
                                Text("+")
                            }
                        }
                        .bold()
                        .frame(width: 75, height: 75)
                        .font(.system(size: 55))
                        .foregroundColor(fontOrenge)
                        .background(backGroundGlay)
                        .clipShape(Circle())
                        .buttonStyle(.plain)
                        Spacer()
                            .frame(width: 25)
                    }
                    Spacer()
                        .frame(height: 35)
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
                    await updateAlarm(notification: await seachNotification(), data: await seachAlarmData() )
                    tabHidden.tabHidden = false
                }
            }
        }
    }
    
    // Notificationに登録されているCalendar Alarmを取得
    func seachNotification() async -> [String] {
        let res = await NotificationManager.instance.getPendingNotifications()
        let newArray = res.filter{$0.contains("calendar")}
        return newArray
    }
    
    //SwiftDataに登録されている情報を取得
    func seachAlarmData() async -> [String] {
        var resArray: [String] = []
        for alarm in calendarAlarts {
            resArray.append("\(alarm.id)")
        }
        return resArray
    }
    
    //過去アラームの削除とデータに差分があれば更新
    func updateAlarm(notification: [String], data: [String]) async {
        print("calendarUpdateStart")
        //過去のアラームを削除
        for alarm in calendarAlarts {
            let (hour, minute) = dateConversion(time: alarm.time)
            if let date: Date = createDateFromComponents(year: alarm.year, month: alarm.month, day: alarm.day, hour: hour, minute: minute) {
                if Date() > date {
                    print("削除", alarm)
                    context.delete(alarm)
                    print("通知済みのアラームデータを削除")
                }
            }
        }
        // dataとNotificationに差がないか確認
        if Set(notification) != Set(data) {
            print("データに差分が発生差分を削除します")
            print(notification, data)
            // 差分を取得
            let differenceNotification = notification.filter {!data.contains($0)}
            let differenceData = data.filter {!notification.contains($0)}
            print(differenceNotification, differenceData)
            
            //差分を削除
            for alarm in calendarAlarts {
                if !differenceNotification.isEmpty {
                    for dif in differenceNotification {
                        if "\(alarm.id)" == dif {
                            context.delete(alarm)
                        }
                        NotificationManager.instance.removeNotification(id: dif)
                    }
                    
                }
                
                if !differenceData.isEmpty{
                    for dif in differenceData {
                        if "\(alarm.id)" == dif {
                            context.delete(alarm)
                        }
                        NotificationManager.instance.removeNotification(id: dif)
                    }
                }
            }
        }
    }
    
    func createDateFromComponents(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents)
    }
}
