//
//  PlayGameController.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 8/4/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import UIKit

class PlayGameController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var playerNameField: UITextField!
    @IBOutlet weak var playGameBtn: RoundButton!
    @IBOutlet weak var playGameWithDefaultBtn: RoundButton!
    @IBOutlet weak var enterPlayerNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
//        self.playerNameField.bec omeFirstResponder()
        // Do any additional setup after loading the view.
    }
    var gameDuration = 0
    var numberOfBubbles = 0
    var playerName : String = ""
    
    @IBAction func settingBtnTapped(_ sender: RoundButton) {
        performSegue(withIdentifier: "showGameSettingSegue", sender: self)
    }
    
    @IBAction func rankingBtnTapped(_ sender: RoundButton) {
        performSegue(withIdentifier: "showRankingSegue", sender: self)
    }
    @IBAction func playGameWithDefaultBtnTapped(_ sender: Any) {
        self.playGame(isDefaultMode: true)
    }
    
    @IBAction func playGameBtnTapped(_ sender: RoundButton) {
        self.playGame(isDefaultMode: false)
    }
    
    private func playGame(isDefaultMode: Bool){
        
        if self.playerNameField.text != ""{
           
            // Set default mode
            if isDefaultMode{
                self.gameDuration =  AppConfig.defaultGameDuration
                self.numberOfBubbles = AppConfig.defaultNumberOfBubbles
            }else{
                self.gameDuration =  GameSettingViewController.getGameDuration()
                self.numberOfBubbles = GameSettingViewController.getNumberOfBubble()
            }
            self.playerName = self.playerNameField.text!
            
            performSegue(withIdentifier: "playGameSegue", sender: self)
            
        }else{
            BubbleAnimation.showEmptyTextFieldAnimation(component: self.enterPlayerNameLbl)
        }
    }
    // Prepare data data for send data to
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playGameSegue"{
            let playGameVC = segue.destination as! PlayGameViewController
            playGameVC.gameDuration = self.gameDuration
            playGameVC.maxBubblesOnFrame = self.numberOfBubbles
            playGameVC.playerName = self.playerName
        }else if segue.identifier == "playGameSegue" {
            let settingGame = segue.destination as! GameSettingViewController
        
            settingGame.setGameDuration(gameDuration: self.gameDuration)
            settingGame.setNumberOfBubble(numberOfBubble: self.numberOfBubbles)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
