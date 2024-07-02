//
//  ContentView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/27.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection = 1
    
    init () {
        UITabBar.appearance().unselectedItemTintColor = .gray
    }
    
    var body: some View {
        ZStack{
            TabView(selection: $selection) {
                TopView()   // Viewファイル①
                    .tabItem {
                        Image(systemName: "clock.fill")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                    .tag(1)
                
                CalendarView()   // Viewファイル②
                    .tabItem {
                        Image(systemName: "calendar.badge.plus")
                    }
                    .tag(2)
            }
            .accentColor(fontOrenge)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Alarm.self)
}
