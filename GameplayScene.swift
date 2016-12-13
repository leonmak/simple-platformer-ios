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
    
    var canMove = false
    var moveLeft = false
    
    private let cloudsController = CloudsController();
    private var cameraDistanceBeforeCreatingNewClouds = CGFloat();
    private let distanceBetweenClouds = CGFloat(240);
    private let minX = CGFloat(-160);
    private let maxX = CGFloat(160);
    
    private var pausePanel: SKSpriteNode?;
    
    override func didMove(to view: SKView) {
        initializeVariables()
    }
    
    override func update(_  : TimeInterval) {
        moveCamera()
        
        managePlayer()
        manageBackgrounds()
        createNewClouds()
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            // If tap right half of screen go right, same for left
            let location = touch.location(in: self)
            
            if location.x > center! {
                moveLeft = false
            } else {
                moveLeft = true
            }
            
            player?.animatePlayer(moveLeft)
            
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
        canMove = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false
        player?.stopPlayerAnimation()
    }
    
    func managePlayer() {
        if canMove {
            player?.movePlayer(moveLeft)
        }
    }
    
    func initializeVariables() {
        center = (self.scene?.size.width)! / (self.scene?.size.height)!
        player = self.childNode(withName: "Player") as? Player!
        
        player?.initializePlayerAndAnimations()
        
        // Also change name in scene
        mainCamera = self.childNode(withName: "Main Camera") as? SKCameraNode!
        
        getBackgrounds()
        
        cloudsController.arrangeCloudsInScene(scene: self.scene!, distaneBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, player: player! , initialClouds: false);
        
    }
    
    func moveCamera() {
        self.mainCamera?.position.y -= 3
    }
    
    func getBackgrounds() {
        bg1 = self.childNode(withName: "BG 1") as? BGClass!
        bg2 = self.childNode(withName: "BG 2") as? BGClass!
        bg3 = self.childNode(withName: "BG 3") as? BGClass!
    }
    
    func manageBackgrounds() {
        bg1?.moveBG(mainCamera!)
        bg2?.moveBG(mainCamera!)
        bg3?.moveBG(mainCamera!)
    }
    
    private func createNewClouds() {
        if cameraDistanceBeforeCreatingNewClouds > mainCamera!.position.y {
            
            cameraDistanceBeforeCreatingNewClouds = mainCamera!.position.y - 400;
            
            cloudsController.arrangeCloudsInScene(scene: self.scene!, distaneBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, player: player! , initialClouds: false);
            
        }
    }
    
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

}

