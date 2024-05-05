//
//  WeekPickView.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/23.
//

import SwiftUI

struct WeekPickView: View {
    
    @Binding var weekDay:[Int]?
    
    let index = [0...6]
    let dayOfWeek = [
        0 : "日曜日",
        1 : "月曜日",
        2 : "火曜日",
        3 : "水曜日",
        4 : "木曜日",
        5 : "金曜日",
        6 : "土曜日"
    ]
    
    var body: some View {
        
        List(index, id: \.self) { i in
            Text("\(i)")
//            Text(dayOfWeek[i])
        }
        
        Text("Hello, World!")
    }
}

