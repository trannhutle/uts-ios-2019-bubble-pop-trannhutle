//
//  PlayGameController.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 8/4/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import UIKit

class StartGameViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var playerNameField: UITextField!
    @IBOutlet weak var playGameBtn: RoundButton!
    @IBOutlet weak var playGameWithDefaultBtn: RoundButton!
    @IBOutlet weak var gameSettingBtn: RoundButton!
    @IBOutlet weak var enterPlayerNameLbl: UILabel!
    @IBOutlet weak var rankingBtn: RoundButton!
    var gameDuration = 0
    var numberOfBubbles = 0
    var playerName : String = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show keyboard when tap on the text field, and dismiss when tap anywhere else and return btn
        self.playerNameField.delegate = self
        self.hideKeyboard()
        
        // listen to the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    // Remove all observer when this screen is destructed
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,  name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self,  name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.settupScreenLayout()
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.hideKeyboard()
    }
    
    
    @IBAction func settingBtnTapped(_ sender: RoundButton) {
        performSegue(withIdentifier: "showGameSettingSegue", sender: self)
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
            // show the eror message when the player's name input text field is empty
            BubbleAnimation.showEmptyTextFieldAnimation(component: self.enterPlayerNameLbl)
        }
    }
    
    private func settupScreenLayout(){
        self.playGameBtn.setTitle( NSLocalizedString("Play",comment:""), for: UIControl.State.normal)
        self.playGameWithDefaultBtn.setTitle(NSLocalizedString("Play with default setting",comment:""), for: UIControl.State.normal)
        self.gameSettingBtn.setTitle(NSLocalizedString("Setting",comment:""), for: UIControl.State.normal)
        self.rankingBtn.setTitle(NSLocalizedString("Ranking",comment:""), for: UIControl.State.normal)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.playerNameField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
}
