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
    @Environment(\.dismiss) var dismiss
    @State var soundList: [String] = [""]
    @Binding var pickSound: String
    
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
                            ForEach(soundList, id: \.self){ sound in
                                Text(sound).tag(sound)
                                
                            }
                        }
                        .labelsHidden()
                        .listRowBackground(backGroundGlay)
                        .foregroundColor(.white)
                        .listRowSeparatorTint(backGroundGlay)
                        .padding(10)
                        .font(.system(size: 25))
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
                    .padding(0)
                    .frame(width: width*0.9)
                    .background(backGroundGlay)
                }
                .padding(0)
                .scrollContentBackground(.hidden)
                .background(backGroundBlack)
                
                Button("戻る"){
                    Task{
                        await stopMusic()
                        dismiss()
                    }
                    
                }
                .buttonStyle(mainButtonStyle())
                Spacer()
                    .frame(height: 1)
            }
            .navigationBarBackButtonHidden(true)
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
    
}
//
//#Preview {
//    soundView()
//}
