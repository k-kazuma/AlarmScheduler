//
//  CalenderView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/20.
//

import SwiftUI

let calendar = Calendar.current



struct CalendarView: View {
    @State var pickDates:[Int] = []
    @State var days:[calenderDay]
    @State var calenderDate: Date
    @State var year: Int
    @State var month: Int
    @State var monthShiftNum: Int = 0
    
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
                                VStack{
                                    Text("\(days[index - days[0].weekday].day)")
                                    if pickDates.contains(days[index - days[0].weekday].day) {
                                        Text("🔴")
                                    }
                                    Spacer()
                                }
                                .onTapGesture {
                                    // pickDatesに値が存在すれば削除、なければ追加
                                    if pickDates.contains(days[index - days[0].weekday].day){
                                        pickDates.removeAll(where: {$0 == days[index - days[0].weekday].day })
                                    } else {
                                        pickDates.append(days[index - days[0].weekday].day)
                                    }
                                    pickDates.sort { $0 < $1 }
                                    print(pickDates)
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
                                Text(pickDates.isEmpty ? "未選択" : "追加する")
                            }
                        }
                        .buttonStyle(mainButtonStyle())
                        .disabled(pickDates.isEmpty)
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
    }
}

func sendCalendarAlarm(year: Int, month: Int, day: Int, hour: Int, minutte: Int, sound: String) async {
    do{
        let addDate = DateComponents(year: year, month: month, day: day, hour: hour, minute: minutte)
        try await NotificationManager.instance.sendCalendarNotification(date: addDate, sound: sound)
    }catch {
        print(error)
    }
}

func generateDays(year: Int, month: Int) -> [calenderDay] {
    var days = [calenderDay]()
    
    // カレンダーと日付コンポーネントを設定
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month)
    
    // 指定された年月の最初の日付を取得
    guard let startDate = calendar.date(from: dateComponents) else {
        fatalError("Invalid date components")
    }
    
    // 指定された年月の全ての日にちを取得
    let range = calendar.range(of: .day, in: .month, for: startDate)!
    
    for day in range {
        let date = calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        let weekday = calendar.component(.weekday, from: date)
        days.append(calenderDay(day: day, weekday: weekday))
    }
    
    return days
}


struct calenderDay {
    let day: Int
    let weekday: Int
    var isActive: Bool = false
}

#Preview{
    CalendarView()
}
