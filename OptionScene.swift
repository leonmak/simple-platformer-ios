//
//  OptionScene.swift
//  jackTheGiant
//
//  Created by Leon on 7/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class OptionScene: SKScene {
    
    private var easyBtn: SKSpriteNode?
    private var mediumBtn: SKSpriteNode?
    private var hardBtn: SKSpriteNode?
    private var sign: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        initializeVariables()
        setSign()
    }
    
    func initializeVariables() {
        easyBtn = self.childNode(withName: "Easy") as? SKSpriteNode!
        mediumBtn = self.childNode(withName: "Medium") as? SKSpriteNode!
        hardBtn = self.childNode(withName: "Hard") as? SKSpriteNode!
        sign = self.childNode(withName: "Sign") as? SKSpriteNode!
    }
    
    func setSign() {
        if GameDataManager.instance.getEasyDifficulty() == true {
            sign?.position.y = (easyBtn?.position.y)!
        } else if GameDataManager.instance.getMediumDifficulty() == true {
            sign?.position.y = (mediumBtn?.position.y)!
        } else if GameDataManager.instance.getHardDifficulty() == true {
            sign?.position.y = (hardBtn?.position.y)!
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            let name = "\(nodes(at: location)[0].name!)"
            
            switch(name) {
            case "Easy", "Medium", "Hard":
                setDifficulty(name)
                
            case "Back":
                let scene = MainMenuScene(fileNamed: "MainMenu")
                scene?.scaleMode = SKSceneScaleMode.aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1))
            
            default:
                break
            }
        }
    }

    fileprivate func setDifficulty(_ difficulty: String) {
        
        switch(difficulty) {
        case "Easy":
            GameDataManager.instance.setEasyDifficulty(true)
            GameDataManager.instance.setMediumDifficulty(false)
            GameDataManager.instance.setHardDifficulty(false)
            break
            
        case "Medium":
            GameDataManager.instance.setEasyDifficulty(false)
            GameDataManager.instance.setMediumDifficulty(true)
            GameDataManager.instance.setHardDifficulty(false)
            break
            
        case "Hard":
            GameDataManager.instance.setEasyDifficulty(false)
            GameDataManager.instance.setMediumDifficulty(false)
            GameDataManager.instance.setHardDifficulty(true)
            break
            
        default:
            break
        }
        
        setSign()
        GameDataManager.instance.saveData()
    }
    
}
