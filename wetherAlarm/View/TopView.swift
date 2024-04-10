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
    @Query(sort: \Alarm.hour) private var alarts: [Alarm]
    @State var on = true
    @State var activeList: [[String : Bool]] = []
    
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
                            let alarms = alarts.map {$0.id}
                            print(res)
                            print(alarms)
                            let a = await UNUserNotificationCenter.current().pendingNotificationRequests()
                            print("####################")
                            print(a)
                            print(a[0].content.title, a[0].content.subtitle)
                        }
                    }
                    Button("reset") {
                        Task{
                            let res = await NotificationManager.instance.getPendingNotifications()
                            for r in res {
                                NotificationManager.instance.removeNotification(id: r)
                            }
                            let alarmes = alarts.map {$0.id}
                            for a in alarmes {
                                print(alarts.first(where: {$0.id == a})!)
                                context.delete(alarts.first(where: {$0.id == a})!)
                            }
                        }
                    }
                    Button("削除"){
                        NotificationManager.instance.removeNotification(id: "alkfjo")
                    }
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
                                    Text("\(alarm.hour)時\(alarm.minute)分")
                                        .swipeActions(edge: .trailing) {
                                            Button(action: {
                                                Task{
                                                    print("選択したアラームを削除")
                                                    alarm.deleteAlarm()
                                                }
                                            }){
                                                Text("削除")
                                            }
                                        }.tint(.red)
                                    
                                    Spacer()
                                    
                                    Toggle(isOn: Bindable(alarm).isActive) {}
                                        .labelsHidden()
                                }
                            }
                            .modifier(ListStyle())
                            
                            
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
            }
            
            
        }
    }
    
    func checkDataNotification() -> Bool {
        
        Task{
            let res = await NotificationManager.instance.getPendingNotifications()
            let alarmes = alarts.map {$0.id}
            
            print(res, alarmes)
        }
        return true
    }
}

#Preview {
    TopView()
        .modelContainer(for: Alarm.self)
}
