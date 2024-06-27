//
//  ContentView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/27.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            
            TopView()   // Viewファイル①
                .tabItem {
                    Image(systemName: "clock.fill")
//                    Label("", systemImage: "clock.fill")
                }
                .tag(1)
            
            CalendarView()   // Viewファイル②
                .tabItem {
                    Image(systemName: "calendar.badge.plus")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
