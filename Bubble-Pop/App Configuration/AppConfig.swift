//
//  AppConfig.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 2/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import Foundation
import UIKit

struct AppConfig{
    static let gameTimeInterval = 1
    static let fadeDuration = 0.3
    static let fadeDeleteDuration = 0.2
    static let similarCategoryScoreRate: Float = 1.5
    static let tableViewRowSpacing = CGFloat(10)
    static let normalCell = "normalCell"
    static let firstCell = "firstCell"
    
    static let defaultGameDuration = 10
    static let defaultNumberOfBubbles = 15
    static let bubbleZIndex: CGFloat = 0.3
    static let onTopZIndex: CGFloat = 1.0
    static let onBottomZIndex: CGFloat = 0.0

    static let layerOpacityHalf: Float = 0.5

    static let bubbleSmallestSize: Float = 30.0
    static let bubbleLargestSize: Float = 70.0
    
    static let textFieldLeftMove: CGFloat = 30
    static let textFieldRighttMove: CGFloat = 60
    
    static let gameOverSound = "gameOver"
    static let newHighScore = "newHighScore"
    static let bubblePopSound = "bubblePopSound"
    static let goGoGoSound = "goGoGo"

    static let mp3Extension = "mp3"

}
