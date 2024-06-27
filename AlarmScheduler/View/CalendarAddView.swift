//
//  CalendarAddView.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/27.
//

import SwiftUI

struct CalendarAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var date = Date(year: 1999, month: 1, day: 1, hour: 7)
    @State var sound = MusicPlayer().soundList[0]
    
    var body: some View {
        ZStack{
            backGroundBlack
                .edgesIgnoringSafeArea(.all)
            VStack{
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .colorInvert()
                    .colorMultiply(.white)
                    .padding(.top, 100)
                
                Spacer()
                VStack{
                    NavigationLink(destination: soundView(pickSound: $sound)){
                        HStack{
                            Text("サウンド")
                            Spacer()
                            Text(sound)
                        }
                        .padding(10)
                        
                    }
                }
                .frame(width: width*0.9)
                .foregroundColor(.white)
                .font(.system(size: 24))
                .background(backGroundGlay)
                .cornerRadius(10)
                Spacer()
                
                Button("追加する"){
//                    sendCalendarAlarm(year: <#T##Int#>, month: <#T##Int#>, day: <#T##Int#>, hour: <#T##Int#>, minutte: <#T##Int#>, sound: <#T##String#>)
                }
                .buttonStyle(mainButtonStyle())
                Button("キャンセル"){
                    dismiss()
                }
                .buttonStyle(mainButtonStyle())
                Spacer()
                    .frame(height: 1)
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CalendarAddView()
}
