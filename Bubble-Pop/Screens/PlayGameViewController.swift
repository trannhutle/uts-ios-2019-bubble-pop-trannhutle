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
    @IBOutlet weak var gameOverImgView: UIImageView!
    @IBOutlet weak var startGameTimerLbl: UILabel!
    @IBOutlet weak var buttonGroupStack: UIView!
    @IBOutlet weak var playerNameLbl: UILabel!
    
    @IBOutlet weak var eatingBubbleImgView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var stackViewContainsEatBubble: UIStackView!
    
    var gameTimer: Timer?
    var countDownTimer: Timer?
    var bubbleList: [Bubble] = []
    var stuffedBubble: StuffedBubble! = nil
    var maxBubblesOnFrame = AppConfig.defaultNumberOfBubbles
    var gameDuration = AppConfig.defaultGameDuration
    var gameDurationCountdown = 0
    var playerName = ""
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
        let scoreLbl = self.eatingBubbleImgView.center
        let locScoreView = self.stackViewContainsEatBubble.convert(scoreLbl, to: self.bottomView)
        
        let img1 = UIImage(named: "eat-5")!
        let img2 = UIImage(named: "eat-6")!
        let img3 = UIImage(named: "eat-4")!
        
        let img4 = UIImage(named: "eat-3")!
        let img5 = UIImage(named: "eat-2")!
        let img6 = UIImage(named: "eat-1")!
        
        PlaySound.playBubbleSound()
        
        self.eatingBubbleImgView.layer.zPosition = 1.0
        
        var animatedImage = UIImage.animatedImage(with: [img1, img2, img3], duration: 5)
        sender.layer.zPosition = 1.0
        self.scoreView.layer.zPosition = 0.1
        
        sender.timer?.invalidate()
        
        Utils.changeFrame(view: sender, toOriginX: locScoreView.x, toOriginY: locScoreView.y, toWidth: 5,  toHeight: 5, duration: 1)
        print("Get touch event")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.eatingBubbleImgView.image = animatedImage
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            animatedImage = UIImage.animatedImage(with: [img4, img5, img6], duration: 0.5)
            self.eatingBubbleImgView.image = animatedImage
        }
        let bubble = sender
        self.updateViewAfterTouchBubble(bubble: bubble)
        //        bubble.removeFromSuperview()
        
    }
    //When btn play again is tapped, the segue would call this current VC and this function is triggered to remove all the history VC
    @IBAction func playAgainTapped(_ sender: UIButton) {
        
        var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
        navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray!
        
    }
    
    // unbind the timer at the current screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if self.isMovingFromParent
        {
            self.gameTimer?.invalidate()
            self.countDownTimer?.invalidate()
        }
    }
    // This funftion is called when user turn the orentation of the phone
    // clear all the bubble on the screen, generate the new ones
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: nil, animation: nil, completion: {
            _ in
            if self.bubbleList.count != 0{
                //Remove all bubble on screen
                self.stuffedBubble.removeAllBubble(bubbleList: self.bubbleList)
                // Generate all new bubble
                self.stuffedBubble.refreshBubbleDisplayFrame(playGameScreen: self)
                self.bubbleList = self.stuffedBubble.sprawBubblesToFrame(numberOfBubbles: self.bubbleList.count,currentBubbleList: [])
                self.stuffedBubble.resetBubbleVelocity(bubbleList:self.bubbleList)
            }
        })
    }
    
    // Prepare data data for send data to
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playAgainSegue"{
            let playGameVC = segue.destination as! PlayGameViewController
            playGameVC.gameDuration = self.gameDuration
            playGameVC.maxBubblesOnFrame = self.maxBubblesOnFrame
            playGameVC.playerName = self.playerName
        }
    }
    
    func getBubbleDisplayFrame() ->UIView {
        return self.bubbleDisplayFrame
    }
    
    private func showStartGameCountdown(){
        // Show timer to start game
        var startTimeCountDown = 2
        self.countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            startGameTimer in
            
            self.startGameTimerLbl.text = String(startTimeCountDown)
            self.startGameTimerLbl.fadeTransition(AppConfig.fadeDuration)
            
            print (startTimeCountDown)
            if startTimeCountDown == 0{
                self.startGameTimerLbl.isHidden = true
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
        self.bubbleList = self.stuffedBubble.sprawBubblesToFrame(numberOfBubbles: self.maxBubblesOnFrame, currentBubbleList: self.bubbleList)
        
        // Set actions during the time interval
        var count  = 0
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            gameTimer in
            
            if self.gameDurationCountdown >= 1{
                // Update time remaining 
                self.gameDurationCountdown -= 1
                self.timerLbl.text = String(self.gameDurationCountdown)
                self.timerLbl.fadeTransition(AppConfig.fadeDuration)
                
                if count % 2 == 0{
                    // Refresh the bubble on frame
                    self.refreshBubbleFrame()
                }
                count += 1
            }else{
                self.gameTimer?.invalidate()
                self.endGame()
            }
        }
    }
    private func endGame(){
        //  Emnplty the bubble list
        self.bubbleList = []
        self.setupLayoutForGameEnding()
        // Save score to db
        if self.currentScore != 0{
            self.ranking.persistNewScoring(playerName: self.playerName, score: Int16(self.currentScore))
        }
    }
    
    private func setupLayoutForGameEnding(){
        // Disable all the touch event for bubble
        self.bubbleDisplayFrame.isUserInteractionEnabled = false
        // Show the buttom button for going to ranking or replay the game
        self.buttonGroupStack.isHidden = false
        self.buttonGroupStack.layer.zPosition = 1.0
        
        // Blur the bubble display frame
        self.bubbleDisplayFrame.layer.opacity = 0.5
        self.bubbleDisplayFrame.layer.zPosition = 0.3
        
        // Show the first place
        if self.currentHighestScore == self.currentScore && self.currentHighestScore != 0{
            PlaySound.playHighScoreSound()
            self.topOneImgView.isHidden = false
            self.topOneImgView.layer.zPosition = 1.0
        }else{
            PlaySound.playGameOverSound()
            self.gameOverImgView.isHidden = false
            self.gameOverImgView.layer.zPosition = 1.0
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
        self.stuffedBubble.resetBubbleVelocity(bubbleList: newBubbleList)
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
                PlaySound.playHighScoreSound()
                let position = self.scoreLbl.frame.origin
                // Show animation for new top 1 user
                BubbleAnimation.showTopOneAnimation(component: self.topOneImgView, container: self.bubbleDisplayFrame, position: position)
                
                self.isNewTopOne = true
            }
        }
    }
    
    private func setupScreenLayout(){
        //Set user player name
        self.playerNameLbl.text = "\(self.playerName)'s score"
        
        //Set border for the lable
        self.timerLbl.layer.borderWidth = 1.0
        self.timerLbl.text = String(self.gameDuration)
        self.scoreLbl.text = String(self.currentScore)
        
        self.gameDurationCountdown = self.gameDuration
        
        //Get highest score
        let highestScore = self.ranking.getHighestScore()
        if nil == highestScore{
            self.topOneScoringLbl.text = NSLocalizedString("No leader",comment:"")
        }else{
            self.currentHighestScore = Int(highestScore!.score)
            self.topOneScoringLbl.text = String(highestScore!.score)
        }
        
        // Disable all the touch event for bubble
        self.bubbleDisplayFrame.isUserInteractionEnabled = true
        // Hide the bottom button for going to ranking or replay the game
        self.buttonGroupStack.isHidden = true
        self.buttonGroupStack.layer.zPosition = 1.0
        
        // Enable the capacity of the bubble display frame
        self.bubbleDisplayFrame.layer.opacity = 1.0
    }
    
    
    
}
