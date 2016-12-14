//
//  MainMenuScene.swift
//  jackTheGiant
//
//  Created by Leon on 7/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    private var musicBtn: SKSpriteNode?;
    private var musicOn = SKTexture(imageNamed: "Music On Button");
    private var musicOff = SKTexture(imageNamed: "Music Off Button");
    
    override func didMove(to view: SKView) {
        musicBtn = self.childNode(withName: "Music") as? SKSpriteNode;

        GameDataManager.instance.initializeGameData();
        setMusic();
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
            
            if nodes(at: location)[0].name == "Highscore" {
                let scene = HighscoreScene(fileNamed: "HighscoreScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsOpenVertical(withDuration: 0.9))
            }
            
            if nodes(at: location)[0].name == "Options" {
                let scene = OptionScene(fileNamed: "OptionScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.doorsOpenVertical(withDuration: 0.9))
            }
            
            if nodes(at: location)[0].name == "Music" {
                handleMusicButton()
            }
            

        }
    }

    // MARK: Music
    
    /// Replace button texture if audio is off
    private func setMusic() {
        if GameDataManager.instance.getIsMusicOn() {
            if AudioManager.instance.isAudioPlayerInitialized() {
                AudioManager.instance.playBGMusic()
                musicBtn?.texture = musicOn
            }
        } else {
            musicBtn?.texture = musicOff
        }
    }
    
    private func handleMusicButton() {
        if GameDataManager.instance.getIsMusicOn() {
            AudioManager.instance.stopBGMusic()
            GameDataManager.instance.setIsMusicOn(false)
            musicBtn?.texture = musicOff
        } else {
            AudioManager.instance.playBGMusic()
            GameDataManager.instance.setIsMusicOn(true)
            musicBtn?.texture = musicOn
        }
        GameDataManager.instance.saveData()
    }
    

}
