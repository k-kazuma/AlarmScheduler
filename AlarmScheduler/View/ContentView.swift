//
//  ContentView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/27.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct ContentView: View {
    
    @State var selection = 1
    @EnvironmentObject var tabHidden: toggleTabBar
    
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
                    .environmentObject(tabHidden)
                
                CalendarView()   // Viewファイル②
                    .tabItem {
                        Image(systemName: "calendar.badge.plus")
                    }
                    .tag(2)
                    .environmentObject(tabHidden)
            }
            .accentColor(fontOrenge)
            .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { tabView in
                tabView.tabBar.isHidden = tabHidden.tabHidden
                    }
        }
    }
}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Alarm.self)
//}
