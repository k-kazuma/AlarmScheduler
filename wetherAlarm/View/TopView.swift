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
                        updateView()
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
                updateView()
            }
            
            
        }
    }
    
    func updateView () {
        Task{
            let res = await NotificationManager.instance.getPendingNotifications()
            let alarms:[String] = await getAlarms()
            
            print(res)
            print(alarms)
            print("#########################")
            
            let differenceA = alarms.filter{ !res.contains($0)}
            let differenceB = res.filter{ !alarms.contains($0)}
            print("SwiftDataとNotificationに差がないか確認します")
            print("SwiftData",differenceA)
            print("Notification",differenceB)
            
            for alarm in alarts {
                for dif in differenceA {
                    if "\(alarm.id)" == dif {
                        alarm.isActive = false
                    }
                }
            }
            for r in res {
                for dif in differenceB {
                    if r == dif {
                        print("削除", dif)
                        NotificationManager.instance.removeNotification(id: dif)
                    }
                }
            }
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
    
}
//
//#Preview {
//    TopView()
//        .modelContainer(for: Alarm.self)
//}
