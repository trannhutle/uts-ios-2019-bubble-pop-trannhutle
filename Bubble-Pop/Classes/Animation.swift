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
}
