//
//  soundView.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/11.
//

import SwiftUI
import AVFoundation

struct soundView: View {
    
    let paths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
    
    var body: some View {
        Button("再生"){
            Task{
                do{
                    try await PlaySound(soundName: "24ctu")
                }catch {
                    print(error)
                }
            }
        }
        Button("停止"){
            stopMusic()
        }
    }
}
