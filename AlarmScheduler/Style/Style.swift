//
//  Style.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/03/31.
//

import Foundation
import SwiftUI

let fontOrenge = Color(red: 240/255, green: 160/255, blue: 8/255)
let backGroundBlack =  Color(red: 69/255, green: 69/255, blue: 69/255)
let backGroundGlay = Color(red: 122/255, green: 122/255 , blue: 122/255)

let bounds = UIScreen.main.bounds
let width = bounds.width
let height = bounds.height

struct mainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width * 0.8)
            .font(.system(size: 24))
            .fontWeight(.bold)
            .padding()
            .background(backGroundGlay)
            .foregroundColor(fontOrenge)
            .cornerRadius(10)
    }
}

struct noButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width * 0.8)
            .font(.system(size: 24))
            .fontWeight(.bold)
            .padding()
            .background(backGroundGlay)
            .foregroundColor(Color.gray)
            .cornerRadius(10)
    }
}

struct delButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width * 0.8)
            .font(.system(size: 24))
            .fontWeight(.bold)
            .padding()
            .background(backGroundGlay)
            .foregroundColor(.red)
            .cornerRadius(10)
            .opacity(0.7)
    }
}


struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View { // カスタムモディファイアの内容
        content
            .foregroundColor(.white)
            .font(.system(size: 35))
            .padding(.leading, 20)
            .padding(.top, 50)
    }
}

struct ListStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: width * 0.9)
            .cornerRadius(3.0)
            .padding(10)
            .listRowBackground(backGroundBlack)
            .listRowSeparatorTint(backGroundGlay)
            .foregroundColor(.white)
            .fontWeight(.bold)
            
    }
}
