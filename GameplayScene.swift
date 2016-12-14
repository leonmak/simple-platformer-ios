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
    
    private let cloudsController = CloudsController();
    private var cameraDistanceBeforeCreatingNewClouds = CGFloat();
    private let distanceBetweenClouds = CGFloat(240);
    private let minX = CGFloat(-160);
    private let maxX = CGFloat(160);
    
    private var pausePanel: SKSpriteNode?;
    
    override func didMove(to view: SKView) {
        initializeVariables()
    }
    
    // Game progresses by moving camera,
    override func update(_  : TimeInterval) {
        moveCamera()
        createNewClouds(initialClouds: false)
        
        animatePlayer()
        moveBGs()
        
        player?.setScore();
        
        // Cleanup
        rmvOutOfScreenChildren()
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
    
    // MARK: Manage player, bg, camera
    /// Animate if player is moving
    func animatePlayer() {
        if isMoving {
            player?.movePlayer(isMovingLeft)
        }
    }
    
    func moveBGs() {
        bg1?.moveBG(mainCamera!)
        bg2?.moveBG(mainCamera!)
        bg3?.moveBG(mainCamera!)
    }
    
    func initializeVariables() {
        
        // Select main camera in scene
        configureSceneElements()
        
        // Initialize clouds w/o collectables
        createNewClouds(initialClouds: true)

    }
    
    /// Decrease camera by 3
    func moveCamera() {
        self.mainCamera?.position.y -= 3
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
    
    /// Create new clouds if mark > camera y position,
    private func createNewClouds(initialClouds: Bool) {
        print(cameraDistanceBeforeCreatingNewClouds)
        print("main cam: \(mainCamera!.position.y)")
        if cameraDistanceBeforeCreatingNewClouds > mainCamera!.position.y {
           cameraDistanceBeforeCreatingNewClouds = mainCamera!.position.y - (self.scene?.size.height)!*3;
            
           cloudsController.arrangeCloudsInScene(scene: self.scene!, distaneBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, player: player!, initialClouds: initialClouds);
            
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
    
    private func rmvOutOfScreenChildren() {
        for child in children {
            if child.position.y > mainCamera!.position.y + self.scene!.size.height {
                print("\(child.name): \(child.position.y)")
                // Split string
                let childName = child.name?.components(separatedBy: " ");
                
                if childName![0] != "BG" {
                    print("rmv clouds/collectable: \(child.name)")
                    child.removeFromParent();
                }
                
            }
        }
    }
    
}

