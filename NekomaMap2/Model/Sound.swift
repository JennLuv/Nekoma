//
//  Sound.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 20/06/24.
//

import AVFoundation

class SoundManager {
    var audioPlayers: [String: AVAudioPlayer] = [:]
    
    func playSound(fileName: String, fileType: String = "mp3", volume: Float = 0.4, loop: Bool = false) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileType) {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.volume = volume
                audioPlayer.numberOfLoops = loop ? -1 : 0
                audioPlayer.play()
                audioPlayers[fileName] = audioPlayer
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    func stopSound(fileName: String) {
        if let audioPlayer = audioPlayers[fileName] {
            audioPlayer.stop()
            audioPlayers.removeValue(forKey: fileName)
        }
    }
}

