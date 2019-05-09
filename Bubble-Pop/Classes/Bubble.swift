//
//  Bubble.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 1/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import Foundation
import UIKit

enum BubbleCategory: Int {
    case red = 1
    case pink = 2
    case green = 5
    case blue = 8
    case black = 10
    case none = 0
}

class Bubble: UIButton{
    
    var colour: CGColor = UIColor.BubbleColor.white.cgColor
    var points: BubbleCategory = BubbleCategory.none
    var velocity: Double = 0.0
    var timer: Timer?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This function is used for drawing the CGRect to the bubble
    override func draw(_ rect: CGRect) {
        
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1    // your desired value
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = self.colour
        shapeLayer.strokeColor = self.colour
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
        
    }
    //  Bubble initialisation
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let prob = Utils.randomProbability()
        switch prob {
        case 0...0.4:
            self.colour = UIColor.BubbleColor.red.cgColor
            self.points = .red
        case 0.4...0.7:
            self.colour = UIColor.BubbleColor.pink.cgColor
            self.points = .pink
        case 0.7...0.85:
            self.colour = UIColor.BubbleColor.green.cgColor
            self.points = .green
        case 0.85...0.95:
            self.colour = UIColor.BubbleColor.blue.cgColor
            self.points = .blue
        case 0.95...1:
            self.colour = UIColor.BubbleColor.black.cgColor
            self.points = .black
        default:
            self.colour = UIColor.BubbleColor.white.cgColor
            self.points = .none
        }
        self.setVelocity()
    }
    
    // Set the bubble velocity, it would be called when the device is changed orentation, create new bubble
    func setVelocity() {
        self.velocity = Double(-1.0)

        if let existingTimer = timer {
            existingTimer.invalidate()
        }

        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer: Timer) in
            if UIDevice.current.orientation.isLandscape {
                self.center = CGPoint(x: self.center.x , y: self.center.y - CGFloat(self.velocity))
            } else {
                self.center = CGPoint(x: self.center.x, y: self.center.y - CGFloat(self.velocity))
            }
        })
        self.timer!.fire()
    }
    
}


