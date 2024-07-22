//
//  CalendarTrashView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/07/22.
//

import SwiftUI
import SwiftData

struct CalendarTrashView: View {
    
    @Query() private var calendarAlarts: [CalendarAlarm]
    @State var pickAlarm:[CalendarAlarm] = []
    @State var days:[calenderDay]
    @State var calenderDate: Date
    @State var year: Int
    @State var month: Int
    @State var monthShiftNum: Int = 0
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var context
    
    @State var isNext: Bool = false
    @EnvironmentObject var tabHidden: toggleTabBar
    
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
                            pickAlarm = []
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
                                let calendarDate = DateComponents(year: year, month: month, day: index - days[0].weekday )
                                
                                // 過去日かどうかを比較
                                if nowDate.year! >= calendarDate.year! && nowDate.month! >= calendarDate.month! && nowDate.day! > calendarDate.day! {
                                    VStack{
                                        Text("\(days[index - days[0].weekday].day)")
                                            .foregroundColor(backGroundGlay)
                                        Spacer()
                                    }
                                } else {
                                    let newArray = calendarAlarts.filter { $0.year == year && $0.month == month && $0.day == days[index - days[0].weekday].day}
                                    if !newArray.isEmpty{
                                        VStack{
                                            Text("\(days[index - days[0].weekday].day)")
                                            VStack{
                                                Text(f.string(from: newArray[0].time ))
                                                ZStack{
                                                    Text("⬜︎")
                                                    if pickAlarm.contains(newArray[0]) {
                                                        VStack{
                                                            
                                                            Image(systemName: "checkmark")
                                                                .foregroundColor(fontOrenge)
                                                        }
                                                    }
                                                }
                                            }
                                            Spacer()
                                        }
                                        .onTapGesture {
                                            // pickDatesに値が存在すれば削除、なければ追加
                                            if pickAlarm.contains(newArray[0]){
                                                pickAlarm.removeAll(where: {$0 == newArray[0] })
                                            } else {
                                                pickAlarm.append(newArray[0])
                                            }
                                            print(pickAlarm)
                                        }
                                    } else {
                                        VStack{
                                            Text("\(days[index - days[0].weekday].day)")
                                            Spacer()
                                        }
                                        .foregroundColor(backGroundGlay)
                                    }
                                }
                            } else {
                                Spacer()
                                    .frame(height: 60)
                            }
                        }
                        .frame(height: 60)
                    }
                    VStack{
                        
                        Button(action: {
                            for alarm in pickAlarm {
                                context.delete(alarm)
                                NotificationManager.instance.removeNotification(id: alarm.id)
                            }
                            dismiss()
                        }){
                            Text(pickAlarm.isEmpty ? "未選択" : "削除")
                        }
                        .buttonStyle(mainButtonStyle())
                        .disabled(pickAlarm.isEmpty)
                        Button("キャンセル"){
                            dismiss()
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
        }
        .onChange(of: isNext) {
            presentationMode.wrappedValue.dismiss()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            tabHidden.tabHidden = true
        }
    }
}

#Preview {
    CalendarTrashView()
}
