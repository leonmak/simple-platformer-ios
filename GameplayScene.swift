//
//  GameplayScene.swift
//  jackTheGiant
//
//  Created by Leon on 6/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

struct ColliderType {
    static let PLAYER: UInt32 = 0;
    static let CLOUD: UInt32 = 1;
    static let DARK_CLOUD_AND_COLLECTABLES: UInt32 = 2;
}

class GameplayScene: SKScene {
    
    var center: CGFloat?
    var player: Player?
    var mainCamera: SKCameraNode?
    var bg1: BGClass?
    var bg2: BGClass?
    var bg3: BGClass?
    
    var isMoving = false
    var isMovingLeft = false
    
    // For creating clouds
    private let cloudsController = CloudsController();
    private var cameraDistanceBeforeCreatingNewClouds = CGFloat();
    private let distanceBetweenClouds = CGFloat(240);
    private let minX = CGFloat(-160);
    private let maxX = CGFloat(160);
    
    // For player out-of-bounds
    private let playerMinX = CGFloat(-214);
    private let playerMaxX = CGFloat(214);
    
    private var pausePanel: SKSpriteNode?;

    // MARK: Initialize

    override func didMove(to view: SKView) {
        initializeVariables()
    }
    
    func initializeVariables() {
        
        // Select main camera in scene
        configureSceneElements()
        
        // Initialize clouds w/o collectables
        createNewClouds(initialClouds: true)
        
    }
    
    private func configureSceneElements() {
        center = (self.scene?.size.width)! / (self.scene?.size.height)!
        
        player = self.childNode(withName: "Player") as? Player!
        player?.initializePlayerAndAnimations()
        
        setCamAndBG()
        setLabels()
        
        // Set instance labels before setting values to labels
        GameplayController.instance.initializeVariables()
        
    }
    
    private func setCamAndBG() {
        mainCamera = self.childNode(withName: "Main Camera") as? SKCameraNode!
        bg1 = self.childNode(withName: "BG 1") as? BGClass!
        bg2 = self.childNode(withName: "BG 2") as? BGClass!
        bg3 = self.childNode(withName: "BG 3") as? BGClass!
    }
    
    private func setLabels() {
        GameplayController.instance.scoreText = self.mainCamera?.childNode(withName: "Score Label") as? SKLabelNode!;
        GameplayController.instance.coinText = self.mainCamera?.childNode(withName: "Coin Label") as? SKLabelNode!;
        GameplayController.instance.lifeText = self.mainCamera?.childNode(withName: "Life Label") as? SKLabelNode!;
    }
    
    
    // MARK: Update
    // Manage player, bg, camera

    /// Progress by moving camera, creating clouds.
    /// Manage player position, movement, bg movement
    ///
    override func update(_  : TimeInterval) {
        manageCamera()
        createNewClouds(initialClouds: false)
        
        managePlayer()
        moveBGs()
        
        player?.setScore();
        
        // Cleanup
        rmvOutOfScreenChildren()
    }
        /// Decrease camera by 3
    func manageCamera() {
        self.mainCamera?.position.y -= 3
    }

    func managePlayer() {
        
        // Animate if player is moving
        if isMoving {
            player?.movePlayer(isMovingLeft)
        }
        
        // Restrict player
        if player!.position.x > playerMaxX {
            player!.position.x = playerMaxX;
        }
        
        if player!.position.x < playerMinX {
            player!.position.x = playerMinX;
        }
        
        // Player fell and died, pause scene, deduct life
        if player!.position.y  > mainCamera!.position.y + (self.scene?.size.height)!/2 {
            self.scene?.isPaused = true;
            
            GameplayController.instance.life -= 1;
            
            if GameplayController.instance.life >= 0 {
                GameplayController.instance.lifeText?.text = "x\(GameplayController.instance.life)"
            } else {
                createEndScorePanel()
            }
            
            Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false);
        }
        
        if player!.position.y + player!.size.height * 3.7 < mainCamera!.position.y {
            self.scene?.isPaused = true;
            
            GameplayController.instance.life -= 1;
            
            if GameplayController.instance.life >= 0 {
                GameplayController.instance.lifeText?.text = "x\(GameplayController.instance.life)"
            } else {
                createEndScorePanel()
            }
            
            Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false);
        }

    }
    
    func moveBGs() {
        bg1?.moveBG(mainCamera!)
        bg2?.moveBG(mainCamera!)
        bg3?.moveBG(mainCamera!)
    }
    
    /// Create new clouds if mark > camera y position,
    private func createNewClouds(initialClouds: Bool) {
        if cameraDistanceBeforeCreatingNewClouds >= mainCamera!.position.y {
           cameraDistanceBeforeCreatingNewClouds = mainCamera!.position.y - (self.scene?.size.height)!*3;
            
           cloudsController.arrangeCloudsInScene(scene: self.scene!, distaneBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, player: player!, initialClouds: initialClouds);
            
        }
    }
    
    /// If have some life, go back to GameplayScene, else save data and go to HighScore scene.
    @objc private func playerDied() {
        if GameplayController.instance.life >= 0 {
            GameDataManager.instance.gameRestartedPlayerDied = true;
            
            let scene = GameplayScene(fileNamed: "GameplayScene");
            scene?.scaleMode = SKSceneScaleMode.aspectFill;
            self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            
        } else {
            if GameDataManager.instance.getEasyDifficulty() {
                let highscore = GameDataManager.instance.getEasyDifficultyScore();
                let coinScore = GameDataManager.instance.getEasyDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameDataManager.instance.setEasyDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameDataManager.instance.setEasyDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            } else if GameDataManager.instance.getMediumDifficulty() {
                let highscore = GameDataManager.instance.getMediumDifficultyScore();
                let coinScore = GameDataManager.instance.getMediumDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameDataManager.instance.setMediumDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameDataManager.instance.setMediumDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            } else if GameDataManager.instance.getHardDifficulty() {
                let highscore = GameDataManager.instance.getHardDifficultyScore();
                let coinScore = GameDataManager.instance.getHardDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameDataManager.instance.setHardDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameDataManager.instance.setHardDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            }
            
            GameDataManager.instance.saveData();
            
            let scene = MainMenuScene(fileNamed: "MainMenu");
            scene?.scaleMode = SKSceneScaleMode.aspectFill;
            self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
        }
    }
    
    // MARK: Touches handler
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            // If tap right half of screen go right, same for left
            let location = touch.location(in: self)
            
            if location.x > center! {
                isMovingLeft = false
            } else {
                isMovingLeft = true
            }
            
            player?.animatePlayer(isMovingLeft)
            
            if nodes(at: location)[0].name == "Pause" {
                self.scene?.isPaused = true;
                createPausePanel();
            }
            
            if nodes(at: location)[0].name == "Resume" {
                self.pausePanel?.removeFromParent();
                self.scene?.isPaused = false;
            }
            
            if nodes(at: location)[0].name == "Quit" {
                let scene = MainMenuScene(fileNamed: "MainMenu");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
        }
        isMoving = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
        player?.stopPlayerAnimation()
    }
    

    // MARK: Create Panels
    private func createPausePanel() {
        
        pausePanel = SKSpriteNode(imageNamed: "Pause Menu");
        let resumeBtn = SKSpriteNode(imageNamed: "Resume Button");
        let quitBtn = SKSpriteNode(imageNamed: "Quit Button 2");
        
        pausePanel?.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        pausePanel?.xScale = 1.6;
        pausePanel?.yScale = 1.6;
        pausePanel?.zPosition = 5;
        
        pausePanel?.position = CGPoint(x: self.mainCamera!.frame.size.width / 2, y: self.mainCamera!.frame.size.height / 2);
        
        resumeBtn.name = "Resume";
        resumeBtn.zPosition = 6;
        resumeBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        resumeBtn.position = CGPoint(x: pausePanel!.position.x, y: pausePanel!.position.y + 25);
        
        quitBtn.name = "Quit";
        quitBtn.zPosition = 6;
        quitBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        quitBtn.position = CGPoint(x: pausePanel!.position.x, y: pausePanel!.position.y - 45);
        
        pausePanel?.addChild(resumeBtn);
        pausePanel?.addChild(quitBtn);
        
        self.mainCamera?.addChild(pausePanel!);
        
    }

    private func createEndScorePanel() {
        let endScorePanel = SKSpriteNode(imageNamed: "Show Score");
        let scoreLabel = SKLabelNode(fontNamed: "Blow");
        let coinLabel = SKLabelNode(fontNamed: "Blow");
        
        endScorePanel.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        endScorePanel.zPosition = 8;
        endScorePanel.xScale = 1.5;
        endScorePanel.yScale = 1.5;
        
        scoreLabel.text = "x\(GameplayController.instance.score)"
        coinLabel.text = "x\(GameplayController.instance.coin)"
        
        endScorePanel.addChild(scoreLabel);
        endScorePanel.addChild(coinLabel);
        
        scoreLabel.fontSize = 50;
        scoreLabel.zPosition = 7;
        
        coinLabel.fontSize = 50;
        coinLabel.zPosition = 7;
        
        endScorePanel.position = CGPoint(x: mainCamera!.frame.size.width / 2, y: mainCamera!.frame.size.height / 2);
        
        scoreLabel.position = CGPoint(x: endScorePanel.position.x - 60, y: endScorePanel.position.y + 10);
        coinLabel.position = CGPoint(x: endScorePanel.position.x - 60, y: endScorePanel.position.y - 105);
        
        mainCamera?.addChild(endScorePanel);
        
    }

    // MARK: Cleanup out of screen
    private func rmvOutOfScreenChildren() {
        for child in children {
            if child.position.y > mainCamera!.position.y + self.scene!.size.height {
                // Split string
                let childName = child.name?.components(separatedBy: " ");
                
                if childName![0] != "BG" {
                    print("rmv clouds/collectable: \(child.name!)")
                    child.removeFromParent();
                }
                
            }
        }
    }
    
}

