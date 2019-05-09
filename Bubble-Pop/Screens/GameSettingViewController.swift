//
//  GameSettingViewController.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 28/4/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import UIKit

class GameSettingViewController: UITableViewController {
    
    @IBOutlet weak var gameDurationLbl: UILabel!
    @IBOutlet weak var numberOfBubbleLbl: UILabel!
    @IBOutlet weak var gameDurationSlider: UISlider!
    @IBOutlet weak var numberOfBubblesSlider: UISlider!
    
    // This is the common variable for
    private static var gameDuration: Int = AppConfig.defaultGameDuration
    private static var numberOfBUbbles:Int = AppConfig.defaultNumberOfBubbles
    
    var currentGameDuration = 0
    var currentNumberOfBubbles = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set value for the labels
        self.gameDurationLbl.text = "\(GameSettingViewController.gameDuration)s"
        self.numberOfBubbleLbl.text = "\(GameSettingViewController.numberOfBUbbles)"
        // Set value for the sliders
        self.numberOfBubblesSlider.value = Float(GameSettingViewController.numberOfBUbbles)
        self.gameDurationSlider.value = Float(GameSettingViewController.gameDuration)
        // Set the current static to current setting
        self.currentGameDuration = GameSettingViewController.gameDuration
        self.currentNumberOfBubbles = GameSettingViewController.numberOfBUbbles
    }
    
    @IBAction func durationSlideChanged(_ sender: UISlider) {
        let sliderValue = lroundf(sender.value)
        self.currentGameDuration = sliderValue
        gameDurationLbl.text = "\(sliderValue)s"
    }
    
    @IBAction func numberOfBubblesSlideChanged(_ sender: UISlider) {
        let sliderValue = lroundf(sender.value)
        self.currentNumberOfBubbles = sliderValue
        numberOfBubbleLbl.text = "\(sliderValue)"
    }
    
    // Save the current settinfg
    @IBAction func saveSetting(_ sender: Any) {
        GameSettingViewController.gameDuration = self.currentGameDuration
        GameSettingViewController.numberOfBUbbles = self.currentNumberOfBubbles
        // return to the setting controller
        _ = self.navigationController?.popViewController(animated: true)
    }
    // Getter and setter
    public static func getGameDuration() -> Int{
        return GameSettingViewController.gameDuration
    }
    public func setGameDuration(gameDuration: Int){
        GameSettingViewController.gameDuration = gameDuration
    }
    public static func getNumberOfBubble() -> Int{
        return GameSettingViewController.numberOfBUbbles
    }
    public  func setNumberOfBubble(numberOfBubble: Int){
        GameSettingViewController.numberOfBUbbles = numberOfBubble
    }
}
