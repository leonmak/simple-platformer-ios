//
//  GameplayController.swift
//  jackTheGiant
//
//  Created by Leon on 14/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import Foundation
import SpriteKit

/// Contains data for the labels of Distance score, Coin score, and life
/// Uses GameDataManager to know if it should reset score

class GameplayController {
    
    // Singleton
    static let instance = GameplayController()
    private init() {}

    var scoreText: SKLabelNode?
    var coinText: SKLabelNode?
    var lifeText: SKLabelNode?

    var score: Int = 0
    var coin: Int = 0
    var life: Int = 0

    func initializeVariables() {
        
        if GameDataManager.instance.gameStartedFromMainMenu {
            GameDataManager.instance.gameStartedFromMainMenu = false
            
            score = -1
            coin = 0
            life = 3
            
            scoreText?.text = "\(score)"
            coinText?.text = "x\(coin)"
            lifeText?.text = "x\(life)"
            
        } else if GameDataManager.instance.gameRestartedPlayerDied {
            GameDataManager.instance.gameRestartedPlayerDied = false
            
            scoreText?.text = "\(score)"
            coinText?.text = "x\(coin)"
            lifeText?.text = "x\(life)"
        }
    }
    
    func incrementScore() {
        score += 1
        scoreText?.text = "\(score)"
    }
    
    func incrementCoin() {
        coin += 1
        
        score += 200
        
        coinText?.text = "x\(coin)"
        scoreText?.text = "\(score)"
    }
    
    func incrementLife() {
        life += 1
        
        score += 300
        
        lifeText?.text = "x\(life)"
        scoreText?.text = "\(score)"
        
        
    }

}
