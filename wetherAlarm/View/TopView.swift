//
//  ContentView.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/03/28.
//

import SwiftUI
import SwiftData

struct TopView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var alarts: [Alarm]
    @State var on = true
    @State var activeList: [[String : Bool]] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                backGroundBlack
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Button("test"){
                        Task {
                            await NotificationManager.instance.notification()
                        }
                    }
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
                            
                            NavigationLink(destination: EditView()){
                                HStack{
                                    Text("\(alarm.hour)時\(alarm.minute)分")
                                        .swipeActions(edge: .trailing) {
                                            Button(action: {
                                                Task{
                                                    print("選択したアラームを削除")
                                                    await NotificationManager.instance.removeNotification(id: alarm.id)
                                                    context.delete(alarm)
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
}

#Preview {
    TopView()
        .modelContainer(for: Alarm.self)
}
