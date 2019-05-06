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
    
    // This is the common variable for
    private static var gameDuration: Int = AppConfig.defaultGameDuration
    private static var numberOfBUbbles:Int = AppConfig.defaultNumberOfBubbles
    
    var currentGameDuration = 0
    var currentNumberOfBubbles = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDurationLbl.text = "\(GameSettingViewController.gameDuration)s"
        numberOfBubbleLbl.text = "\(GameSettingViewController.numberOfBUbbles)"
        
        // Set the current static to current setting
        self.currentGameDuration = GameSettingViewController.gameDuration
        self.currentNumberOfBubbles = GameSettingViewController.numberOfBUbbles

        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingToParent{
            
        }
    }
    @IBAction func saveSetting(_ sender: Any) {
        GameSettingViewController.gameDuration = self.currentGameDuration
        GameSettingViewController.numberOfBUbbles = self.currentNumberOfBubbles
        
        // return to the setting controller
        _ = self.navigationController?.popViewController(animated: true)
    }
    public static func getGameDuration() -> Int{
        return GameSettingViewController.gameDuration
    }
    public static func setGameDuration(gameDuration: Int){
        GameSettingViewController.gameDuration = gameDuration
    }
    public static func getNumberOfBubble() -> Int{
        return GameSettingViewController.numberOfBUbbles
    }
    public static func setNumberOfBubble(numberOfBubble: Int){
        GameSettingViewController.numberOfBUbbles = numberOfBubble
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
