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
    @State var soundList: [String] = [""]
    @Binding var pickSound: String
    
    
    var body: some View {
        
        VStack{
            List{
                Picker("", selection: $pickSound) {
                    ForEach(soundList, id: \.self){ sound in
                        Text(sound).tag(sound)
                            
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: pickSound) {
                    Task{
                        do{
                            print("onChange" + pickSound)
                            await stopMusic()
                            try await PlaySound(fileName: pickSound)
                        } catch{
                            print(error)
                        }
                    }
                    print(pickSound)
                    
                }
            }
            
            Button("停止"){
                Task{
                    await stopMusic()
                }
            }
        }
        .onAppear(){
            Task{
                do{
                    soundList = try await getSoundList()
                } catch{
                    print(error)
                }
            }
        }
    }
        
}
//
//#Preview {
//    soundView()
//}
