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

    override func didMove(to view: SKView) {
        initializeVariables()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCamera()
        managePlayer()
        manageBackgrounds()
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
    
}

