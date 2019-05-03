//
//  PlayGameViewController.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 29/4/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import UIKit

class PlayGameViewController: UIViewController {
    
    @IBOutlet weak var bubbleDisplayFrame: UIView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var topOneScoringLbl: UILabel!
    @IBOutlet weak var topOneImgView: UIImageView!
    @IBOutlet weak var startGameTimerLbl: UILabel!
    @IBOutlet weak var buttonGroupStack: UIView!
    
    var gameTimer: Timer?
    var bubbleList: [Bubble] = []
    var stuffedBubble: StuffedBubble! = nil
    var maxBubblesOnFrame = 30
    var gameDuration = 2
    var lastBubblePoint : Int = 0
    var currentScore: Int = 0
    var ranking: Ranking = Ranking()
    var currentHighestScore = 0
    var isNewTopOne = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the layout for the this game
        self.setupScreenLayout()
        
        // Initialise the bubble utilities
        self.stuffedBubble = StuffedBubble(playGameScreen: self)
        print("displayed all the bubble on the screen")
        
        // Start playing game
        // Show start game countdown and after that start playing game
        self.showStartGameCountdown()
        
    }
    @IBAction func bubbleIsTouched(_ sender: Bubble){
        
        print("Get touch event")
        
        let bubble = sender
        self.updateViewAfterTouchBubble(bubble: bubble)
        bubble.removeFromSuperview()
        
    }
    //Play agin
    @IBAction func playAgainTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "playAgainSegue", sender: self)
    }
    
    @IBAction func showRankingTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showRankingSegue", sender: self)
    }
    
    // This funftion is called when user turn the orentation of the phone
    // clear all the bubble on the screen, generate the new ones
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: nil, animation: nil, completion: {
            _ in
            //Remove all bubble on screen
            self.stuffedBubble.removeAllBubble(bubbleList: self.bubbleList)
            // Generate all new bubble
            self.stuffedBubble.refreshBubbleDisplayFrame(playGameScreen: self)
            self.bubbleList = self.stuffedBubble.sprawBubblesToFrame(numberOfBubbles: self.bubbleList.count,currentBubbleList: [])
        })
    }
    func getBubbleDisplayFrame() ->UIView {
        return self.bubbleDisplayFrame
    }
    private func showStartGameCountdown(){
        // Show timer to start game
        var startTimeCountDown = 2
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            startGameTimer in
            
            self.startGameTimerLbl.text = String(startTimeCountDown)
            self.startGameTimerLbl.fadeTransition(AppConfig.fadeDuration)
            
            print (startTimeCountDown)
            if startTimeCountDown == 0{
                self.startGameTimerLbl.removeFromSuperview()
                startGameTimer.invalidate()
                
                // Triiger function to playing game
                self.stuffedBubble.refreshBubbleDisplayFrame(playGameScreen: self)
                self.startPlayingGame()
            }
            startTimeCountDown -= 1
        }
    }
    
    private func startPlayingGame(){

        // Spraw the bubble on the screen
        self.stuffedBubble.refreshBubbleDisplayFrame(playGameScreen: self)
        self.bubbleList = self.stuffedBubble.sprawBubblesToFrame(numberOfBubbles: 30, currentBubbleList: self.bubbleList)
        
        // Set actions during the time interval
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            gameTimer in
            
            if self.gameDuration >= 1{
                // Update time remaining 
                self.gameDuration -= 1
                self.timerLbl.text = String(self.gameDuration)
                self.timerLbl.fadeTransition(AppConfig.fadeDuration)
                
                // Refresh the bubble on frame
                self.refreshBubbleFrame()
            }else{
                self.gameTimer?.invalidate()
                self.endGame()
            }
        }
    }
    private func endGame(){
        self.setupLayoutForGameEnding()
        
        // Save score to db
        self.ranking.persistNewScoring(playerName: "Test", score: Int16(self.currentScore))
    }
    
    private func setupLayoutForGameEnding(){
        
        // Disable all the touch event for bubble
        self.bubbleDisplayFrame.isUserInteractionEnabled = false
        // Show the buttom button for going to ranking or replay the game
        self.buttonGroupStack.isHidden = false
        self.buttonGroupStack.layer.zPosition = 1.0
        
        // Blur the bubble display frame
        self.bubbleDisplayFrame.layer.opacity = 0.5
        
        // Show the first place
        if self.currentHighestScore == self.currentScore{
            self.bubbleDisplayFrame.layer.zPosition = 0.3
            self.topOneImgView.isHidden = false
            self.topOneImgView.layer.zPosition = 1.0
        }
    }
    
    // Refresh bubble frame
    @objc private func refreshBubbleFrame(){
        // Remove random bubbles on the frame
        self.bubbleList  = self.stuffedBubble.removeBubbles(bubbleList: self.bubbleList)
        self.stuffedBubble.refreshBubbleDisplayFrame(playGameScreen: self)
        // Generate new bubble
        let newBubbleNumber = self.maxBubblesOnFrame - self.bubbleList.count
        let newBubbleList =  self.stuffedBubble.sprawBubblesToFrame(numberOfBubbles: newBubbleNumber, currentBubbleList: self.bubbleList)
        
        // Update new bubbles to current frame
        self.bubbleList = newBubbleList
    }
    
    //Update view after user tabbeb bubble
    private func updateViewAfterTouchBubble(bubble: Bubble){
        
        var bubbleScore = bubble.points.rawValue
        // Check if the previous bubble is similar with the current one for multipling 1.5 times score
        if bubble.points.rawValue == self.lastBubblePoint{
            bubbleScore = Int((Float(bubble.points.rawValue) * AppConfig.similarCategoryScoreRate))
        }
        self.currentScore += bubbleScore
        
        // Update to view
        self.scoreLbl.text = String(self.currentScore)
        self.scoreLbl.fadeTransition(AppConfig.fadeDuration)
        
        // Check if the current score is the highest score
        self.updateTopScoring()
        
        //Set the last bubble
        self.lastBubblePoint = bubble.points.rawValue
    }
    
    private func updateTopScoring(){
        if self.currentHighestScore < self.currentScore{
            self.currentHighestScore = self.currentScore
            self.topOneScoringLbl.text = String(self.currentScore)
            if !self.isNewTopOne{
                
                let position = self.scoreLbl.frame.origin
                // Show animation for new top 1 user
                BubbleAnimation.showTopOneAnimation(component: self.topOneImgView, container: self.bubbleDisplayFrame, position: position)
            
                self.isNewTopOne = true
            }
            // TODO show the message, if user breaks the current record for the first time
        }
    }
    
    private func setupScreenLayout(){
        //Set border for the lable
        self.timerLbl.layer.borderWidth = 1.0
        self.timerLbl.text = String(self.gameDuration)
        self.scoreLbl.text = String(self.currentScore)
        
        //Get highest score
        let highestScore = self.ranking.getHighestScore()
        if nil == highestScore{
            self.topOneScoringLbl.text = NSLocalizedString("No leader",comment:"")
        }else{
            self.currentHighestScore = Int(highestScore!.score)
            self.topOneScoringLbl.text = String(highestScore!.score)
        }
    }
}
