//
//  Alarm.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/01.
//

import Foundation



func dateConversion(time: Date) ->  (Int, Int)  {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    
    let time = dateFormatter.string(from: time).split(separator: ":")
    let hour = Int(time[0])!
    let minute = Int(time[1])!
    
    return (hour, minute)
}
