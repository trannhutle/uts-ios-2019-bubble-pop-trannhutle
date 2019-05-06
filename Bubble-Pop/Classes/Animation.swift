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
    
    static func showEmptyTextFieldAnimation(component: UILabel){
        let currentTextColor = component.textColor
        component.textColor = UIColor.BubbleColor.red
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            component.transform = CGAffineTransform(translationX: component.bounds.origin.x + 30, y: component.bounds.origin.y)
        }, completion: {
            _ in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
                component.transform = CGAffineTransform(translationX: component.bounds.origin.x - 60, y: component.bounds.origin.y)
            }, completion: {
                _ in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
                    component.transform = CGAffineTransform(translationX: component.bounds.origin.x + 30, y: component.bounds.origin.y)
                }, completion: {
                    _ in
                    component.transform = .identity
                    component.textColor = currentTextColor
                })
            })
        })
    }
}
