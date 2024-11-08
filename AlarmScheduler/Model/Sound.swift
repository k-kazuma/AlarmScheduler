//
//  Sound.swift
//  wetherAlarm
//
//  Created by 熊谷知馬 on 2024/04/12.
//

import Foundation
import UIKit
import AVFoundation


class MusicPlayer: ObservableObject {
    @Published var musicPlayer:AVAudioPlayer = AVAudioPlayer()
    @Published var soundList:[String] = [""]
    @Published var playingSoundName = ""
    
    init(){
        do{
            soundList = try getSoundList()
        } catch {
            print(error)
        }
    }
    
    func PlaySound (fileName: String) throws {
        if let path = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            
            print("path:",path)
            print("url:",url)
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer.play()
                playingSoundName = getPlayingSound()
            } catch {
                print("音楽ファイルの再生に失敗しました")
            }
        }
    }
    
    func stopMusic() {
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            playingSoundName = getPlayingSound()
        }
    }
    
    func getSoundList() throws -> [String] {
        let fileManager = FileManager()
        // ファイル一覧の場所であるpathを文字列で取得
        let path = Bundle.main.bundlePath
        
        do {
            // pathにあるファイル名文字列で全て取得
            let files = try fileManager.contentsOfDirectory(atPath: path)
            // 文字列のファイル名が配列で取得できる
            let mp3FileURLs = files.filter { $0.hasSuffix(".mp3") }
            let fileNamesWithoutExtension = mp3FileURLs.map { $0.replacingOccurrences(of: ".mp3", with: "") }
            
            let predefinedOrder = ["目覚まし時計１", "目覚まし時計２", "コンガ"]
            
            let sortedFileNames = fileNamesWithoutExtension.sorted { (first, second) -> Bool in
                if let firstIndex = predefinedOrder.firstIndex(of: first), let secondIndex = predefinedOrder.firstIndex(of: second) {
                    return firstIndex < secondIndex
                } else if predefinedOrder.contains(first) {
                    return true
                } else if predefinedOrder.contains(second) {
                    return false
                } else {
                    return first < second
                }
            }
            
            return sortedFileNames
        } catch {
            throw error
        }
    }
    
    func getPlayingSound() -> String {
        guard musicPlayer.isPlaying else {
            return ""
        }
        if let soudName = musicPlayer.url?.deletingPathExtension().lastPathComponent {
            return soudName
        }
        return ""
    }
    
    
}

