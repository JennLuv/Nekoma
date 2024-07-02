//
//  Sound.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 20/06/24.
//

import AVFoundation

protocol SoundFile {
    var rawValue: String { get }
}

enum BGM: String, SoundFile {
    case homescreen = "homescreen"
    case death = "death"
    case boss = "boss"
    case gameplay = "gameplay"
    case victory = "victory"
}

enum ButtonSFX: String, SoundFile {
    case swapFish = "swap_fish"
    case swapWeapon = "swap_weapon"
    case start = "start"
}

enum PlayerSFX: String, SoundFile {
    case playerAttack = "player_attack"
    case playerBlessing = "player_blessing"
    case playerDeath = "player_death"
    case playerHurt = "player_hurt"
    case playerWalking = "player_walking"
}

enum EnemySFX: String, SoundFile {
    case enemyAttack = "enemy_attack"
    case enemyHurt = "enemy_hurt"
}

enum ChestSFX: String, SoundFile {
    case chestOpened = "chest_opened"
    case itemPickUp = "item_pickup"
}

enum WeaponSFX: String, SoundFile {
    case arrow = "arrow"
    case gunshot = "gunshot"
    case swordKatanaScythe = "sword_katana_scythe"
}

enum PrisonSFX: String, SoundFile {
    case prison = "prison"
}


class SoundManager {
    var audioPlayers: [String: AVAudioPlayer] = [:]
    
    func playSound(fileName: SoundFile, fileType: String = "mp3", volume: Float = 0.4, loop: Bool = false) {
        // print("playSound")
        if let url = Bundle.main.url(forResource: fileName.rawValue, withExtension: fileType) {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.volume = volume
                audioPlayer.numberOfLoops = loop ? -1 : 0
                audioPlayer.play()
                audioPlayers[fileName.rawValue] = audioPlayer
            } catch {
                // print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    func stopSound(fileName: SoundFile) {
        // print("stopSound")
        if let audioPlayer = audioPlayers[fileName.rawValue] {
            audioPlayer.stop()
            audioPlayers.removeValue(forKey: fileName.rawValue)
        }
    }
}
