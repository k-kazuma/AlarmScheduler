//
//  Sound.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/12.
//

import Foundation
import UIKit
import AVFoundation


var musicPlayer: AVAudioPlayer!

func PlaySound (soundName: String) async throws {
    do{
        guard let music = NSDataAsset(name: soundName) else {
            return
        }
        let musicData = music.data
        musicPlayer = try AVAudioPlayer(data: musicData)
        musicPlayer.play()
    }catch {
        throw error
    }
}

func stopMusic() async {
    if musicPlayer != nil {
        musicPlayer.stop()
    }
}

func getSoundList() async throws -> [String] {
    let fileManager = FileManager()
    // ファイル一覧の場所であるpathを文字列で取得
    let path = Bundle.main.bundlePath

    do {
        // pathにあるファイル名文字列で全て取得
        let files = try fileManager.contentsOfDirectory(atPath: path)
        // 文字列のファイル名が配列で取得できる
        let mp3FileURLs = files.filter { $0.hasSuffix(".mp3") }
        let fileNamesWithoutExtension = mp3FileURLs.map { $0.replacingOccurrences(of: ".mp3", with: "") }
        
        return fileNamesWithoutExtension
    } catch {
        throw error
    }
}
