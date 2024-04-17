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

func PlaySound (fileName: String) async throws {
    if let path = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer?.play()
            } catch {
                print("音楽ファイルの再生に失敗しました")
            }
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
