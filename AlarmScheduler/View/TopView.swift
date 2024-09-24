//
//  ContentView.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/03/28.
//

import SwiftUI
import SwiftData
import UserNotifications



struct TopView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var tabHidden: toggleTabBar
    @Query(sort: \Alarm.time) private var alarts: [Alarm]
    @State var on = true
    @State var activeList: [[String : Bool]] = []
    @State var swipeAction = false
    
    
    let f = DateFormatter()
    let f2 = DateFormatter()
    let calendar = Calendar.current
    
    @State var nextTime: Alarm?
    @State var nextDayIndex: Int = 0
    @State var nextAlarmDay: Date = Date()
    
    init(){
        f.dateStyle = .none
        f.timeStyle = .short
        
        f2.dateFormat = "M月d日"
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                backGroundBlack
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    
                    //開発用リセットボタン
                    //                                        Button("reset") {
                    //                                            Task{
                    //                                                let res = await NotificationManager.instance.getPendingNotifications()
                    //                                                for r in res {
                    //                                                    NotificationManager.instance.removeNotification(id: r)
                    //                                                }
                    //                                                let alarmes = alarts.map {$0.id}
                    //                                                for a in alarmes {
                    //                                                    print(alarts.first(where: {$0.id == a})!)
                    //                                                    context.delete(alarts.first(where: {$0.id == a})!)
                    //                                                }
                    //                                            }
                    //                                        }
                    
                    HStack{
                        Text("次のアラーム")
                            .modifier(TitleModifier())
                        Spacer()
                    }
                    VStack{
                        if swipeAction {
                            Button(action:{
                                Task{
                                    (nextTime, nextDayIndex) = await getNextAlarm()
                                    nextAlarmDay = Date()
                                    nextAlarmDay = calendar.date(byAdding: .day, value: nextDayIndex, to: nextAlarmDay)!
                                    swipeAction = false
                                }
                            }){
                                Image(systemName: "clock.arrow.circlepath")
                            }
                            .foregroundColor(fontOrenge)
                            .padding(3)

                        } else {
                            if let next = nextTime {
                                HStack{
                                    Text(f2.string(from: nextAlarmDay))
                                    Text(f.string(from: next.time))
                                }
                            } else {
                                Text("なし")
                            }
                        }
                        // 下線
                        Rectangle()
                            .frame(width: width*0.9, height: 2)
                            .foregroundColor(backGroundGlay)
                    }
                    .font(.title)
                    //                    .onAppear(){
                    //                        Task{
                    //                            (nextTime, nextDayIndex) = await getNextAlarm()
                    //                            nextAlarmDay = Date()
                    //                            nextAlarmDay = calendar.date(byAdding: .day, value: nextDayIndex, to: nextAlarmDay)!
                    //                        }
                    //                    }
                    
                    // 設定済みのアラームがあればListを返し、なければTextを返す
                    if alarts.isEmpty {
                        Spacer()
                        Text("アラームなし")
                        Spacer()
                    } else {
                        List(alarts) { alarm in
                            NavigationLink(destination: EditView(alarm: alarm)){
                                ZStack{
                                    HStack{
                                        VStack{
                                            HStack{
                                                Text(f.string(from: alarm.time))
                                                    .swipeActions(edge: .trailing) {
                                                        Button(action: {
                                                            swipeAction = true
                                                            do{
                                                                print("選択したアラームを削除")
                                                                try alarm.deleteAlarm(id: alarm.id)
                                                            } catch{
                                                                print(error)
                                                            }
                                                        }){
                                                            Text("削除")
                                                        }
                                                    }.tint(.red)
                                                Spacer()
                                            }
                                            HStack{
                                                if alarm.weekDay.isEmpty {
                                                    Text("繰り返しなし")
                                                    
                                                }else if alarm.weekDay == [0,1,2,3,4,5,6] {
                                                    Text("毎日")
                                                } else if alarm.weekDay == [1,2,3,4,5] {
                                                    Text("平日")
                                                } else {
                                                    ForEach(alarm.weekDay, id: \.self) { week in
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
                                                Spacer()
                                            }
                                            .font(.system(size: 15))
                                            
                                        }
                                        Spacer()
                                        
                                        Toggle(isOn: Bindable(alarm).isActive) {}
                                            .labelsHidden()
                                            .onChange(of: alarm.isActive){
                                                Task{
                                                    do{
                                                        try await alarm.toggleAlarm(id: alarm.id)
                                                        (nextTime, nextDayIndex) = await getNextAlarm()
                                                        nextAlarmDay = Date()
                                                        nextAlarmDay = calendar.date(byAdding: .day, value: nextDayIndex, to: nextAlarmDay)!
                                                    } catch{
                                                        print(error)
                                                    }
                                                }
                                            }
                                            .onChange(of: alarts){
                                                Task{
                                                    (nextTime, nextDayIndex) = await getNextAlarm()
                                                    nextAlarmDay = Date()
                                                    nextAlarmDay = calendar.date(byAdding: .day, value: nextDayIndex, to: nextAlarmDay)!
                                                }
                                            }
                                    }
                                    if alarm.skipWeek != nil {
                                        HStack{
                                            Text("スキップ中")
                                        }
                                        .frame(width: 330, height: 65)
                                        .background(Color.black)
                                        .opacity(0.7)
                                    }
                                }
                            }
                            .modifier(ListStyle())
                            .font(.system(size: 30))
                            .onAppear(){
                                if let skipweek = alarm.skipWeek {
                                    print(alarm.skipDate!)
                                    print("スキップしてるよ")
                                    print(skipweek)
                                } else {
                                    print(alarm)
                                    print("スキップしてないよ")
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                    
                    // AddButton
                    HStack{
                        Spacer()
                        Button(action: {
                            print("Button")
                            
                        }) {
                            NavigationLink(destination: AddAlarmView()){
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
                        .frame(height: 30)
                }
            }
            .onAppear() {
                Task {
                    try await checkSkip()
                    await updateView()
                    tabHidden.tabHidden = false
                }
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    Task {
                        try await checkSkip()
                        await updateView()
                        tabHidden.tabHidden = false
                    }
                }
                
            }
            
            
        }
        .foregroundColor(.white)
    }
    
    func updateView () async {
        print("update start")
        Task{
            print("Task started")
            let res = await NotificationManager.instance.getPendingNotifications()
            print("Fetched res:", res)
            
            let alarms:[String] = await getAlarms()
            print("Fetched alarms:", alarms)
            
            
            print(res)
            print(alarms)
            print("#########################")
            
            let differenceA = alarms.filter{ !res.contains($0)}
            let differenceB = res.filter{ !alarms.contains($0)}
            print("SwiftDataとNotificationに差がないか確認します")
            print("SwiftData",differenceA)
            print("Notification",differenceB)
            
            // ActiveなアラームがUserNotificationに登録されていなければisActiveをfalseにする。
            //繰り返しなしにのみ対応
            for alarm in alarts {
                for dif in differenceA {
                    if "\(alarm.id)" == dif {
                        print("isFalse")
                        alarm.isActive = false
                    }
                }
            }
            
            // SwiftData上にないアラームがNotificationに登録されていれば削除
            for r in res {
                for dif in differenceB {
                    if r == dif {
                        // スキップ機能で設置したアラームを削除しないようコンティニューする
                        if dif.contains("skip") || dif.contains("calendar") {
                            continue
                        }
                        print("削除", dif)
                        NotificationManager.instance.removeNotification(id: dif)
                    }
                }
            }
            // 次のアラーム時間を更新
            
            (nextTime, nextDayIndex) = await getNextAlarm()
            nextAlarmDay = Date()
            nextAlarmDay = calendar.date(byAdding: .day, value: nextDayIndex, to: nextAlarmDay)!
            
        }
    }
    
    func getAlarms() async -> [String] {
        var resArray: [String] = []
        for alarm in alarts {
            if alarm.isActive{
                if alarm.weekDay.isEmpty{
                    resArray.append("\(alarm.id)")
                }else {
                    for week in alarm.weekDay {
                        resArray.append("\(alarm.id)-\(week)")
                    }
                }
            }
        }
        return resArray
    }
    
    // 次回アラーム日時を取得
    func getNextAlarm() async -> (Alarm?, Int) {
        
        //現在の曜日を0-6で取得
        let today = Date()
        var todayWeekDay = calendar.component(.weekday, from: today) - 1
        // 比較用の時分を取得
        let nowHourMinute = Date(year: 1999, month: 1, day: 1)
        var getNextAlarm = false
        
        // 現在の曜日で設置されているアラームがあれば、現在時刻より後の時分か確認し値を返す
        for alarm in alarts {
            if alarm.skipWeek == todayWeekDay {
                continue
            }
            if alarm.weekDay.contains(todayWeekDay) && alarm.isActive && nowHourMinute < alarm.time || alarm.weekDay.isEmpty && alarm.isActive && nowHourMinute < alarm.time {
                getNextAlarm = true
                print(f.string(from: nowHourMinute))
                print(f.string(from: alarm.time))
                print("return today", alarm)
                return (alarm, 0)
            }
        }
        
        // 次の日
        if todayWeekDay == 6 {
            todayWeekDay = 0
        } else {
            todayWeekDay += 1
        }
        
        for alarm in alarts {
            if alarm.skipWeek == todayWeekDay {
                continue
            }
            if alarm.weekDay.contains(todayWeekDay) && alarm.isActive || alarm.weekDay.isEmpty && alarm.isActive && nowHourMinute > alarm.time {
                getNextAlarm = true
                print("return tommor", alarm)
                return (alarm, 1)
            }
        }
        
        // todayActiveAlarmがfalseなら本日アクティブなアラームは存在しない
        if !getNextAlarm {
            var n = 0
            
            // 本日のアラームはないため明日一致するか初めに一致したものが次回アラームとなる
            while n < 7 {
                //                print(n)
                for alarm in alarts {
                    if alarm.skipWeek == todayWeekDay {
                        continue
                    }
                    if alarm.weekDay.contains(todayWeekDay) && alarm.isActive {
                        print("return", alarm)
                        return (alarm, n + 1)
                    }
                }
                if todayWeekDay == 6 {
                    todayWeekDay = 0
                } else {
                    todayWeekDay += 1
                }
                n += 1
            }
        }
        print("retuen nil")
        //todayWeekDayを初期化
        todayWeekDay = calendar.component(.weekday, from: today) - 1
        //　alarm.weekDay.count == 1 の条件分岐をここに追記する
        
        var n = 0
        
        while n < 7 {
            for alarm in alarts {
                // スキップ中のアラーム有無確認
                if alarm.skipWeek != nil {
                    //スキップ中のアラームをtodayWeekDayと比較
                    if alarm.skipWeek == todayWeekDay && alarm.isActive && alarm.weekDay.count < 2 {
                        print(alarm.weekDay)
                        return(alarm, n+7)
                    }
                }
            }
            if todayWeekDay == 6 {
                todayWeekDay = 0
            } else {
                todayWeekDay += 1
            }
            n += 1
        }
        return (nil, 0)
    }
    
    // スキップ中のアラームが有無確認、スキップ中アラームあればスキップした日時を超えているか確認、超えていればスキップ解除
    func checkSkip() async throws {
        for alarm in alarts {
            if let skipDate = alarm.skipDate {
                let now = Date()
                print("今とスキップ日時を比較")
                print(now)
                print(skipDate)
                
                if skipDate < now {
                    
                    do {
                        print("スキップ削除")
                        // 一度全て削除して再設置する
                        //削除
                        if alarm.weekDay.isEmpty {
                            NotificationManager.instance.removeNotification(id: "\(alarm.id)")
                        } else {
                            for week in alarm.weekDay {
                                NotificationManager.instance.removeNotification(id: "\(alarm.id)-\(week)")
                            }
                            for num in [7, 14, 21, 28] {
                                NotificationManager.instance.removeNotification(id: "\(alarm.id)-akip\(num)")
                            }
                        }
                        alarm.skipWeek = nil
                        alarm.skipDate = nil
                        
                        //設置
                        try await NotificationManager.instance.sendNotification(id: alarm.id, time: alarm.time, sound: alarm.sound, weekDay: alarm.weekDay)
                    } catch {
                        throw error
                    }
                } else {
                    print("まだスキップした日時を越えていないよ")
                }
            } else{
                print("スキップ中のアラームないよ")
            }
        }
    }
    
}

//#Preview {
//    TopView()
//        .modelContainer(for: Alarm.self)
//}

