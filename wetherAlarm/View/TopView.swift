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
    @Query(sort: \Alarm.time) private var alarts: [Alarm]
    @State var on = true
    @State var activeList: [[String : Bool]] = []
    
    let f = DateFormatter()
    
    init(){
        f.dateStyle = .none
        f.timeStyle = .short
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                backGroundBlack
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    
                    // 開発用ボタン
                    Button("getAlarm"){
                        Task{
                            let res = await NotificationManager.instance.getPendingNotifications()
                            guard !alarts.isEmpty else {
                                print("アラームなし")
                                return
                            }
                            
                            var alarms:[String] = []
                            
                            for alarm in alarts {
                                if alarm.isActive{
                                    if alarm.weekDay.isEmpty{
                                        alarms.append("\(alarm.id)")
                                    }else {
                                        for week in alarm.weekDay {
                                            alarms.append("\(alarm.id)-\(week)")
                                        }
                                    }
                                }
                            } 
                            let difference = checkDataNotification(date: alarms, notification: res)
                            print(difference)
                            print(res)
                            
                            for alarm in alarts {
                                for dif in difference {
                                    if "\(alarm.id)" == dif {
                                        alarm.isActive = false
                                    }
                                }
                            }
                            
                            //                            let a = await UNUserNotificationCenter.current().pendingNotificationRequests()
                            //                            print("####################")
                            //                            print(a)
                            //                            print(a[0].content.title, a[0].content.subtitle)
                        }
                    }
                    //                    Button("reset") {
                    //                        Task{
                    //                            let res = await NotificationManager.instance.getPendingNotifications()
                    //                            for r in res {
                    //                                NotificationManager.instance.removeNotification(id: r)
                    //                            }
                    //                            let alarmes = alarts.map {$0.id}
                    //                            for a in alarmes {
                    //                                print(alarts.first(where: {$0.id == a})!)
                    //                                context.delete(alarts.first(where: {$0.id == a})!)
                    //                            }
                    //                        }
                    //                    }
                    //                    Button("削除"){
                    //                        NotificationManager.instance.removeNotification(id: "alkfjo")
                    //                    }
                    //
                    //
                    //                    Button("paths"){
                    //                        Task{
                    //                            print(try await getSoundList())
                    //                        }
                    //                    }
                    // 開発用ボタン
                    
                    HStack{
                        Text("アラーム")
                            .modifier(TitleModifier())
                        Spacer()
                    }
                    
                    // 設定済みのアラームがあればListを返し、なければTextを返す
                    if alarts.isEmpty {
                        Spacer()
                        Text("アラームなし")
                            .foregroundColor(.white)
                        Spacer()
                    } else {
                        List(alarts) { alarm in
                            NavigationLink(destination: EditView(alarm: alarm)){
                                HStack{
                                    Text(f.string(from: alarm.time))
                                        .swipeActions(edge: .trailing) {
                                            Button(action: {
                                                Task{
                                                    do{
                                                        print("選択したアラームを削除")
                                                        try alarm.deleteAlarm(id: alarm.id)
                                                    } catch{
                                                        print(error)
                                                    }
                                                }
                                            }){
                                                Text("削除")
                                            }
                                        }.tint(.red)
                                    
                                    Spacer()
                                    
                                    Toggle(isOn: Bindable(alarm).isActive) {}
                                        .labelsHidden()
                                        .onChange(of: alarm.isActive){
                                            do{
                                                try alarm.toggleAlarm(id: alarm.id)
                                            } catch{
                                                print(error)
                                            }
                                        }
                                }
                            }
                            .modifier(ListStyle())
                            .font(.system(size: 30))
                            
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
                        .frame(width: 82, height: 82)
                        .font(.system(size: 55))
                        .foregroundColor(fontOrenge)
                        .background(backGroundGlay)
                        .clipShape(Circle())
                        .buttonStyle(.plain)
                        Spacer()
                            .frame(width: 25)
                    }
                }
            }.onAppear() {
                Task{
                    let res = await NotificationManager.instance.getPendingNotifications()
                    guard !alarts.isEmpty else {
                        print("アラームなし")
                        return
                    }
                    
                    var alarms:[String] = []
                    
                    for alarm in alarts {
                        if alarm.isActive{
                            if alarm.weekDay.isEmpty{
                                alarms.append("\(alarm.id)")
                            }else {
                                for week in alarm.weekDay {
                                    alarms.append("\(alarm.id)-\(week)")
                                }
                            }
                        }
                    }
                    let difference = checkDataNotification(date: alarms, notification: res)
                    print(difference)
                    print(res)
                    
                    for alarm in alarts {
                        for dif in difference {
                            if "\(alarm.id)" == dif {
                                alarm.isActive = false
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    
    func checkDataNotification(date: [String], notification: [String]) -> [String] {
        date.filter{ !notification.contains($0)}
    }
}

#Preview {
    TopView()
        .modelContainer(for: Alarm.self)
}
