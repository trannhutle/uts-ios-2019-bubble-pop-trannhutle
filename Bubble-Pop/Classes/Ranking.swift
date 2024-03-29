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
    // Persist the new score into the databse
    func persistNewScoring(playerName: String, score: Int16){
        self.appDelegate.saveScore(playerName: playerName, score: score)
    }
    
    // Get the highest score on the databse
    func getHighestScore() -> Score?{
        let standingList = self.getUserScoringList()
        if standingList.count > 0{
            return standingList.sorted(by: {$0.score > $1.score})[0]
        }
        return nil
    }
    
    // Get the ranking list with out sort
    func getUserScoringList() -> [Score]{
        let retrievedStandingList = self.appDelegate.getStandingList()
        var scoreList:[Score] = []
        for i in retrievedStandingList{
            scoreList.append(self.parseScoreEntityToScoreObject(score: i))
        }
        return scoreList
    }
    // Get the ranking list sorted  by descending
    func getUserScoringListDesc() -> [Score]{
        return self.getUserScoringList().sorted(by: {$0.score > $1.score})
    }
    
    // Parse entity to object
    private func parseScoreEntityToScoreObject(score: ScoreEntity) -> Score{
        let newScore = Score(name: score.playerName!, score: score.score)
        return newScore
    }
}
