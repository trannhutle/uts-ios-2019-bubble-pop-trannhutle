//
//  Utils.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 2/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import Foundation
import UIKit
class Utils {
    
    // Random the float number
    static func randomProbability() -> Float{
        return Float(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    // Random the position what inside the frame
    static func randomPositionInsideFrame(maxX: Float, offsetX: Float, maxY: Float, offsetY: Float) -> CGPoint {
        let x = CGFloat( self.randomProbability() * maxX + offsetX)
        let y = CGFloat( self.randomProbability() * maxY + offsetY)
        return CGPoint(x: x, y: y)
    }
    
    // Random the float number between range number
    static func randomFloatBetween(smallNumber: Float, bigNumber: Float) -> Float {
        let diff: Float = bigNumber - smallNumber
        return ((Float(UInt(arc4random()) % (UInt(RAND_MAX) + 1)) / Float(RAND_MAX)) * diff) + smallNumber
    }
    
    // Random the list of integer smaller than n number
    static func randomIntInRange(maxNumber: Int) -> [Int]{
        var randomNunbers  = Set<Int>()
        
        let listSize = Int(arc4random_uniform(UInt32(maxNumber))) + 1
        print("max number: \(maxNumber)")
        print ("random number to remove: \(listSize)")
        while randomNunbers.count < listSize{
            let randomNumb = Int(arc4random_uniform(UInt32(maxNumber)))
            randomNunbers.insert(randomNumb)
        }
        print ("random index to remove: \(randomNunbers)")
        return Array(randomNunbers)
    }
    // This function is referenced from https://stackoverflow.com/questions/44769265/how-to-animate-scaling-and-moving-a-uilabel-then-set-its-transform-back-to-the?rq=1
    static func changeFrame(view: UIView,
                            toOriginX newOriginX: CGFloat,
                            toOriginY newOriginY: CGFloat,
                            toWidth newWidth: CGFloat,
                            toHeight newHeight: CGFloat,
                            duration: TimeInterval)
    {
        let oldFrame = view.frame
        let newFrame = CGRect(x: newOriginX, y: newOriginY, width: newWidth, height: newHeight)
        
        let translation = CGAffineTransform(translationX: newFrame.midX - oldFrame.midX,
                                            y: newFrame.midY - oldFrame.midY)
        let scaling = CGAffineTransform(scaleX: newFrame.width / oldFrame.width,
                                        y: newFrame.height / oldFrame.height)
        
        let transform = scaling.concatenating(translation)
        
        UIView.animate(withDuration: duration, animations: {
            view.transform = transform
        }) { _ in
            view.transform = .identity
            view.frame = newFrame
            view.removeFromSuperview()
        }
    }
    
    static func copyUIImageViewIntance(uiImageView: UIImageView)  -> UIImageView{
        let uiImageViewCp = UIImageView()
        uiImageViewCp.frame.origin.x = uiImageView.frame.origin.x
        uiImageViewCp.frame.origin.y = uiImageView.frame.origin.y
        uiImageViewCp.frame.size = CGSize(width: uiImageView.frame.width, height: uiImageView.frame.height)
        uiImageViewCp.image = uiImageView.image!
        uiImageViewCp.isHidden = false
        uiImageViewCp.layer.zPosition = 1.0
        return uiImageViewCp
    }
    static func isEven(number : Int)-> Bool{
        return number % 2 == 0
    }
}
