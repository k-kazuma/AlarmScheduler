//
//  CalenderView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/20.
//

import SwiftUI
import SwiftData

let calendar = Calendar.current

struct CalendarAddView: View {
    @Query() private var calendarAlarts: [CalendarAlarm]
    @State var pickDates:[Int]
    @State var days:[calenderDay]
    @State var calenderDate: Date
    @State var year: Int
    @State var month: Int
    @State var monthShiftNum: Int
    @State var isNext: Bool
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var tabHidden: toggleTabBar
    
    init(){
        //今月のカレンダー取得
        calenderDate = calendar.date(byAdding: .month, value: 0, to: Date())!
        pickDates = []
        monthShiftNum = 0
        isNext = false
        year = calendar.component(.year, from: Date())
        month = calendar.component(.month, from: Date())
        days = generateDays(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()))
    }
    
    var body: some View {
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
                        pickDates = []
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
                                        Text(f.string(from: newArray[0].time ))
                                        Spacer()
                                    }
                                    .foregroundColor(backGroundGlay)
                                } else {
                                    VStack{
                                        Text("\(days[index - days[0].weekday].day)")
                                        Spacer()
                                        ZStack{
                                            Text("⬜︎")
                                            if pickDates.contains(days[index - days[0].weekday].day) {
                                                VStack{
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(fontOrenge)
                                                }
                                            }
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
                    
                    Button(action: {}){
                        NavigationLink(destination: CalendarAddTimeView(year: year, month: month, days: pickDates, comp: $isNext)){
                            Text(pickDates.isEmpty ? "未選択" : "追加する")
                        }
                    }
                    .buttonStyle(mainButtonStyle())
                    .disabled(pickDates.isEmpty)
                    Button("戻る"){
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
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            tabHidden.tabHidden = true
            print(isNext)
            if isNext {
                presentationMode.wrappedValue.dismiss()
            }
        }
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
}
//
//#Preview{
//    CalendarAddView()
//}
