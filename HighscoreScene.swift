//
//  HighscoreScene.swift
//  jackTheGiant
//
//  Created by Leon on 7/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class HighscoreScene: SKScene {
    
    
    private var scoreLabel: SKLabelNode?
    private var coinLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        getReference()
        setScore()
    }
    
    private func getReference() {
        scoreLabel = self.childNode(withName: "Score Label") as? SKLabelNode!
        coinLabel = self.childNode(withName: "Coin Label") as? SKLabelNode!
    }
    
    private func setScore() {
        if GameDataManager.instance.getEasyDifficulty() {
            scoreLabel?.text = String(GameDataManager.instance.getEasyDifficultyScore())
            coinLabel?.text = String(GameDataManager.instance.getEasyDifficultyCoinScore())
        } else if GameDataManager.instance.getMediumDifficulty() {
            scoreLabel?.text = String(GameDataManager.instance.getMediumDifficultyScore())
            coinLabel?.text = String(GameDataManager.instance.getMediumDifficultyCoinScore())
        } else if GameDataManager.instance.getHardDifficulty() {
            scoreLabel?.text = String(GameDataManager.instance.getHardDifficultyScore())
            coinLabel?.text = String(GameDataManager.instance.getHardDifficultyCoinScore())
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if nodes(at: location)[0].name == "Back" {
                let scene = MainMenuScene(fileNamed: "MainMenu")
                scene?.scaleMode = SKSceneScaleMode.aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1))
            }
            
        }
    }

}
