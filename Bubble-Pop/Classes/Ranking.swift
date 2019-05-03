//
//  Ranking.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 3/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import Foundation
import UIKit

class Ranking{
    var standingList: [Score] = []
    var appDelegate: AppDelegate
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        standingList = self.getUserScoringList()
    }
    func persistNewScoring(playerName: String, score: Int16){
        self.appDelegate.saveScore(playerName: playerName, score: score)
    }
    func getHighestScore() -> Score?{
        let standingList = self.getUserScoringList()
        if standingList.count > 0{
            return standingList.sorted(by: {$0.score > $1.score})[0]
        }
        return nil
    }
    func getUserScoringList() -> [Score]{
        let retrievedStandingList = self.appDelegate.getStandingList()
        var scoreList:[Score] = []
        for i in retrievedStandingList{
            scoreList.append(self.parseScoreEntityToScoreObject(score: i))
        }
        return scoreList
    }
    private func parseScoreEntityToScoreObject(score: ScoreEntity) -> Score{
        let newScore = Score(name: score.playerName!, score: score.score)
        return newScore
    }
}
