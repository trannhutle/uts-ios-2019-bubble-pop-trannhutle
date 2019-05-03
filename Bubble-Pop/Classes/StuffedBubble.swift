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
    
    func sprawBubblesToFrame(numberOfBubbles: Int, currentBubbleList: [Bubble]) -> [Bubble]{
        self.bubbleList = currentBubbleList
        for _ in 0...numberOfBubbles{
            addBubble()
        }
        return self.bubbleList
    }
    func removeBubbles(bubbleList: [Bubble]) -> [Bubble]{
        let randomBubbleIndex = Utils.randomNumbersInRange(maxNumber: bubbleList.count)
        var bubbleList = bubbleList
        for i in randomBubbleIndex{
            bubbleList[i].removeFromSuperview()
        }
        for i in randomBubbleIndex.sorted(by: >){
            bubbleList.remove(at: i)
        }
        return bubbleList
    }
    func removeAllBubble(bubbleList: [Bubble]){
        for bubble in bubbleList{
            bubble.removeFromSuperview()
        }
    }
    private func addBubble(){
        var isIntersected = true
        while isIntersected {
            // Innitialise the position of the bubble on the frame
            let bubblePosition = self.getBubbleLocationInFrame()
            let tempPositionView = UIView(frame: bubblePosition)
            // Tmporary add the bubble to the view
            self.playGameScreen.getBubbleDisplayFrame().addSubview(tempPositionView)
            // Check if the position is intersected with the others
            if !checkIntersecting(view: tempPositionView){
                let bubble = Bubble(frame: bubblePosition)
                
                bubble.layer.zPosition = 0.3
                
                bubble.addTarget(self.playGameScreen, action: #selector(self.playGameScreen.bubbleIsTouched(_:)), for: UIControl.Event.touchUpInside)
                self.playGameScreen.getBubbleDisplayFrame().addSubview(bubble)
                bubbleList.append(bubble)
                isIntersected = false
            }
            // Remove temp node from the view
            tempPositionView.removeFromSuperview()
        }
    }
    func refreshBubbleDisplayFrame(playGameScreen: PlayGameViewController){
        let bubbleDisplayFrame  = playGameScreen.getBubbleDisplayFrame()
        self.frameWidth = bubbleDisplayFrame.bounds.width
        self.frameHeight = bubbleDisplayFrame.bounds.height
        self.playGameScreen = playGameScreen
    }
    private func getBubbleLocationInFrame()-> CGRect{
        let maxX = Float(self.frameWidth)
        let offsetX: Float = 0.0
        let maxY = Float(self.frameHeight)
        let offsetY: Float = 0.0
        let randomPosition = Utils.randomPositionInsideFrame(maxX: maxX, offsetX: offsetX, maxY: maxY, offsetY: offsetY)
        let size =  CGSize(width: 50, height: 50)
        return CGRect(origin: randomPosition, size: size)
    }
    private func checkIntersecting(view: UIView) -> Bool{
        let addedBubbleList = self.bubbleList
        for b in addedBubbleList{
            if (view.frame.intersects(b.frame) || isIntersectWithBound(view: view)){
                return true
            }
        }
        return false
    }
    private func isIntersectWithBound(view: UIView) -> Bool {
        if ((self.playGameScreen.getBubbleDisplayFrame().bounds).intersection(view.frame).equalTo(view.frame)) {
            return false
        } else {
            return true
        }
    }
}
