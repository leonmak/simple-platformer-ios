//
//  MainMenuScene.swift
//  jackTheGiant
//
//  Created by Leon on 7/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var highscoreBtn: SKSpriteNode?
    

    override func didMove(to view: SKView) {
        highscoreBtn = self.childNode(withName: "Highscore") as? SKSpriteNode!
        
        GameDataManager.instance.initializeGameData();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if nodes(at: location)[0].name == "Start Game" {
                
                // Set before going to gameplayscene
                GameDataManager.instance.gameStartedFromMainMenu = true;
                
                let scene = GameplayScene(fileNamed: "GameplayScene");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
            if nodes(at: location)[0] == highscoreBtn {
                let scene = HighscoreScene(fileNamed: "HighscoreScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsOpenVertical(withDuration: 0.9))
            }
            
            if nodes(at: location)[0].name == "Option" {
                let scene = HighscoreScene(fileNamed: "OptionScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsOpenVertical(withDuration: 0.9))
            }

        }
    }

}
