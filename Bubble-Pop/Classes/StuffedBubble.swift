//
//  BubbleList.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 2/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import Foundation
import UIKit

class StuffedBubble{
    var bubbleList : [Bubble] = []
    var frameHeight: CGFloat = 0.0
    var frameWidth:CGFloat = 0.0
    var playGameScreen: PlayGameViewController
    
    init(playGameScreen: PlayGameViewController) {
        // Get bubble display frame
        self.playGameScreen = playGameScreen
        self.refreshBubbleDisplayFrame(playGameScreen: playGameScreen)
    }
    
    // Draw the bubble inside the bubble frame, make sure the bubble is not overlapped
    func sprawBubblesToFrame(numberOfBubbles: Int, currentBubbleList: [Bubble]) -> [Bubble]{
        self.bubbleList = currentBubbleList
        for _ in 0...numberOfBubbles{
            addBubble()
        }
        return self.bubbleList
    }
    
    // Randomly remove the bubbles on screnn. This function is called when refresh bubble every n seconds
    func removeBubbles(bubbleList: [Bubble]) -> [Bubble]{
        let randomBubbleIndex = Utils.randomIntInRange(maxNumber: bubbleList.count)
        var bubbleList = bubbleList
        for i in randomBubbleIndex{
            bubbleList[i].fadeDelete(AppConfig.fadeDeleteDuration)
        }
        for i in randomBubbleIndex.sorted(by: >){
            bubbleList.remove(at: i)
        }
        return bubbleList
    }
    
    // Remove all bubbles on the bubble frame
    func removeAllBubble(bubbleList: [Bubble]){
        for bubble in bubbleList{
            bubble.removeFromSuperview()
        }
    }
    
    // Reset bubble moving on the bubble frame screen
    func resetBubbleVelocity(bubbleList: [Bubble]){
        for i in 0..<bubbleList.count{
            bubbleList[i].setVelocity()
        }
    }
    
    // Keep update the bubble frame, when the device's orentation change or initialise the bubble frame
    func refreshBubbleDisplayFrame(playGameScreen: PlayGameViewController){
        let bubbleDisplayFrame  = playGameScreen.getBubbleDisplayFrame()
        self.frameWidth = bubbleDisplayFrame.bounds.width
        self.frameHeight = bubbleDisplayFrame.bounds.height
        self.playGameScreen = playGameScreen
    }
    
    // Append the bubble into to the bubble frame
    private func addBubble(){
        var isIntersected = true
        while isIntersected {
            
            // Initialise the random temporary bubble position on bubble frame
            let bubblePosition = self.getBubbleLocationInFrame()
            
            // Set the position for bubble view
            let tempPositionView = UIView(frame: bubblePosition)
            // Add the bubble to bubble frame for checking
            self.playGameScreen.getBubbleDisplayFrame().addSubview(tempPositionView)
            
            // If it is not intersected with the other bubble, add it in to the bubble frame
            if !checkIntersecting(view: tempPositionView){
                
                let bubble = Bubble(frame: bubblePosition)
                // Set the bubble z-index for 0.3 it would display under the bottom button view
                bubble.layer.zPosition = AppConfig.bubbleZIndex
                
                // Add the bubble into the bubble frame
                bubble.addTarget(self.playGameScreen, action: #selector(self.playGameScreen.bubbleIsTouched(_:)), for: UIControl.Event.touchUpInside)
                self.playGameScreen.getBubbleDisplayFrame().addSubview(bubble)
                
                bubbleList.append(bubble)
                isIntersected = false
            }
            // Remove temp node from the view
            tempPositionView.removeFromSuperview()
        }
    }
    
    // Randomly initialise the bubble location on the scren
    private func getBubbleLocationInFrame()-> CGRect{
        let maxX = Float(self.frameWidth)
        let offsetX: Float = 0.0
        let maxY = Float(self.frameHeight)
        let offsetY: Float = 0.0
        
        // Random the pososition of the bubble on the screen
        let randomPosition = Utils.randomPositionInsideFrame(maxX: maxX, offsetX: offsetX, maxY: maxY, offsetY: offsetY)
        
        // Random bubble size
        let randomSize: CGFloat = CGFloat(Utils.randomFloatBetween(smallNumber: AppConfig.bubbleSmallestSize, bigNumber: AppConfig.bubbleLargestSize))
        let size =  CGSize(width: randomSize, height: randomSize)
        return CGRect(origin: randomPosition, size: size)
    }
    
    // Checking the bubble is intersected
    private func checkIntersecting(view: UIView) -> Bool{
        let addedBubbleList = self.bubbleList
        for b in addedBubbleList{
            if (view.frame.intersects(b.frame) || isIntersectWithBound(view: view)){
                return true
            }
        }
        return false
    }
    
    // Checking the bubble is intersected with the bubble frame
    private func isIntersectWithBound(view: UIView) -> Bool {
        if ((self.playGameScreen.getBubbleDisplayFrame().bounds).intersection(view.frame).equalTo(view.frame)) {
            return false
        } else {
            return true
        }
    }
}
