//
//  PlaySound.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 8/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import AVFoundation

class PlaySound{
    
    static var player: AVAudioPlayer?
    
    static func playBubbleSound() {
        playASound(soundFileName: "bubblePopSound", fileExtension: "mp3")
    }
    static func playHighScoreSound() {
        playASound(soundFileName: "newHighScore", fileExtension: "mp3")
    }
    static func playGameOverSound() {
        playASound(soundFileName: "gameOver", fileExtension: "mp3")
    }
    
    static func playASound(soundFileName: String, fileExtension: String){
        guard let url = Bundle.main.url(forResource: soundFileName, withExtension: fileExtension) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            PlaySound.player  = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
        } catch let error {
            print(error.localizedDescription)
        }
        PlaySound.player!.prepareToPlay()
        PlaySound.player!.play()
    }
}
