//
//  soundTest.swift
//  AlarmScheduler
//
//  Created by 熊谷知馬 on 2024/06/28.
//

import SwiftUI
import AudioToolbox

struct soundTest: View {
    var body: some View {
        Button("on"){
            if let soundURL = Bundle.main.url(forResource: "sms-received1", withExtension: "caf") {
                var soundID: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
                AudioServicesPlaySystemSound(soundID)
            } else {
                print("miss")
            }
        }
    }
}

#Preview {
    soundTest()
}
