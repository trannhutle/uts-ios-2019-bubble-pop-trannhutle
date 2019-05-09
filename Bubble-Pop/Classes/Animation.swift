//
//  Animation.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 3/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import Foundation
import UIKit

class BubbleAnimation{
    
    static func showTopOneAnimation(component: UIImageView, container: UIView, position: CGPoint){
        let uiImageView = Utils.copyUIImageViewIntance(uiImageView: component)
        container.addSubview(uiImageView)
        Utils.changeFrame(view: uiImageView, toOriginX: position.x, toOriginY: position.y, toWidth: 5,  toHeight: 5, duration: 1)
    }
    
    // Show the notification to the screen when user does not input their name
    static func showEmptyTextFieldAnimation(component: UILabel){
        let currentTextColor = component.textColor
        component.textColor = UIColor.BubbleColor.red
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            component.transform = CGAffineTransform(translationX: component.bounds.origin.x + AppConfig.textFieldRighttMove, y: component.bounds.origin.y)
        }, completion: {
            _ in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
                component.transform = CGAffineTransform(translationX: component.bounds.origin.x + AppConfig.textFieldLeftMove, y: component.bounds.origin.y)
            }, completion: {
                _ in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
                    component.transform = CGAffineTransform(translationX: component.bounds.origin.x + AppConfig.textFieldRighttMove, y: component.bounds.origin.y)
                }, completion: {
                    _ in
                    component.transform = .identity
                    component.textColor = currentTextColor
                })
            })
        })
    }
    
    static func popBubble(bubble: Bubble, bubbleDisplayFrame: UIView ){
        
        PlaySound.playBubbleSound()

        let pointLbl = UILabel(frame: bubble.frame)
        let bubblePopping = UIImageView(frame: bubble.frame)
        
        pointLbl.center.x = pointLbl.center.x + pointLbl.frame.size.width / 2.0 +  CGFloat(5)
        pointLbl.center.y = pointLbl.center.y - pointLbl.frame.size.width +  CGFloat(5)
        
        let movementTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer: Timer) in  //apply the bubble velocity to the pop animations
            let velocity = -1.0
            if UIDevice.current.orientation.isLandscape {
                pointLbl.center = CGPoint(x: pointLbl.center.x + CGFloat(velocity), y: pointLbl.center.y)
                bubblePopping.center = CGPoint(x: bubblePopping.center.x + CGFloat(velocity), y: bubblePopping.center.y)
            } else {
                pointLbl.center = CGPoint(x: pointLbl.center.x, y: pointLbl.center.y - CGFloat(velocity))
                bubblePopping.center = CGPoint(x: bubblePopping.center.x, y: bubblePopping.center.y - CGFloat(velocity))
            }
        })
        pointLbl.text = " +\(bubble.points.rawValue)"
        
        bubbleDisplayFrame.addSubview(bubblePopping)
        bubblePopping.animationImages = [
            UIImage(named: "bubble-pop-1"),
            UIImage(named: "bubble-pop-2"),
            UIImage(named: "bubble-pop-3"),
            UIImage(named: "bubble-pop-4"),
            UIImage(named: "bubble-pop-5")
            ] as? [UIImage]
        
        bubblePopping.animationDuration = 0.3
        bubblePopping.animationRepeatCount = 1
        
        bubbleDisplayFrame.addSubview(pointLbl)
        bubbleDisplayFrame.addSubview(bubblePopping)
        bubblePopping.startAnimating()
        
        bubble.removeFromSuperview()
        
        // Show bubble after the sound is played
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            pointLbl.removeFromSuperview()
            bubblePopping.removeFromSuperview()
            movementTimer.invalidate()
        }
    }
    
    static func showEatingBubbleAnimation(bubble: Bubble, eatBubbleView: UIImageView, moveToPoint: CGPoint ){
        let img1 = UIImage(named: "eat-5")!
        let img2 = UIImage(named: "eat-6")!
        let img3 = UIImage(named: "eat-4")!
        
        let img4 = UIImage(named: "eat-3")!
        let img5 = UIImage(named: "eat-2")!
        let img6 = UIImage(named: "eat-1")!
        
        PlaySound.playBubbleSound()
        bubble.timer?.invalidate()
        
        // Set two views on the top
        eatBubbleView.layer.zPosition = AppConfig.onTopZIndex
        bubble.layer.zPosition = AppConfig.onTopZIndex
        
        // Initialise the open mouth images
        var animatedImage = UIImage.animatedImage(with: [img1, img2, img3], duration: 5)
        
        //move the bubble to mouth position
        Utils.changeFrame(view: bubble, toOriginX: moveToPoint.x, toOriginY: moveToPoint.y, toWidth: 5,  toHeight: 5, duration: 1)
        
        // Open mounth
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            eatBubbleView.image = animatedImage
        }
        
        // Close mounth image
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            animatedImage = UIImage.animatedImage(with: [img4, img5, img6], duration: 0.5)
            eatBubbleView.image = animatedImage
        }
    }
}
