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
                            
                            HStack{
                                Text("\(alarm.hour)時\(alarm.minute)分")
                                    .swipeActions(edge: .trailing) {
                                        Button(action: {
                                            print("選択したアラームを削除")
                                            context.delete(alarm)
                                        }){
                                            Text("削除")
                                        }
                                    }.tint(.red)
                                
                                Spacer()
                                
                                Toggle(isOn: Bindable(alarm).isActive) {}
                                    .labelsHidden()
                            }
                            .modifier(ListStyle())
                            
                            
                        }
                        .scrollContentBackground(.hidden)
                    }
                    
                    // AddButton
                    Button(action: {
                        print("Button")
                        
                    }) {
                        NavigationLink(destination: AddAlarmView()){
                            HStack{
                                Spacer()
                                Text("+")
                                    .bold()
                                    .frame(width: 82, height: 82)
                                    .font(.system(size: 55))
                                    .foregroundColor(fontOrenge)
                                    .background(backGroundGlay)
                                    .clipShape(Circle())
                                Spacer()
                                    .frame(width: 15)
                            }
                            
                        }
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
