//
//  soundView.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/11.
//

import SwiftUI
import AVFoundation

struct soundView: View {
    
    //    let paths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
    @Environment(\.dismiss) var dismiss
    @Binding var pickSound: String
    @StateObject var musicPlayer = MusicPlayer()
    
    var body: some View {
        
        ZStack{
            backGroundBlack
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("アラーム音を選択")
                        .modifier(TitleModifier())
                    Spacer()
                }
                Form{
                    Section{
                        Picker("", selection: $pickSound) {
                            ForEach(musicPlayer.soundList, id: \.self){ sound in
                                HStack{
                                    Text(sound).tag(sound)
                                        .foregroundColor(.white)
                                    Spacer()
                                    if musicPlayer.playingSoundName == sound {
                                        Button("▫️"){
                                            musicPlayer.stopMusic()
                                        }
                                    } else {
                                        Button("▶︎"){
                                            do{
                                                musicPlayer.stopMusic()
                                                try musicPlayer.PlaySound(fileName: sound)
                                                pickSound = sound
                                            } catch{
                                                print(error)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        .accentColor(fontOrenge)
                        .labelsHidden()
                        .listRowBackground(backGroundGlay)
                        .foregroundColor(.white)
                        .listRowSeparatorTint(backGroundGlay)
                        .padding(10)
                        .font(.system(size: 25))
                        .pickerStyle(.inline)
                        .onChange(of: pickSound) {
                            
                            do{
                                musicPlayer.stopMusic()
                                try musicPlayer.PlaySound(fileName: pickSound)
                            } catch{
                                print(error)
                            }
                            
                        }
                    }
                    .padding(0)
                    .frame(width: width*0.9)
                    .background(backGroundGlay)
                }
                .padding(0)
                .scrollContentBackground(.hidden)
                .background(backGroundBlack)
                
                Button("戻る"){
                    Task{
                        musicPlayer.stopMusic()
                        dismiss()
                    }
                    
                }
                .buttonStyle(mainButtonStyle())
                Spacer()
                    .frame(height: 1)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
}
//
//#Preview {
//    soundView()
//}
