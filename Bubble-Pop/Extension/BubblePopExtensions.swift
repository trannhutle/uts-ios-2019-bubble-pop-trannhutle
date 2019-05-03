//
//  BubblePopExtensions.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 2/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    struct BubbleColor {
        static var red: UIColor{
            return UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        }
        static var pink: UIColor{
            return UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 0.6)
        }
        static var green: UIColor{
            return UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        }
        static var blue: UIColor{
            return UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        }
        static var black: UIColor{
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        }
        static var white: UIColor{
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
    }
}
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
}
}
