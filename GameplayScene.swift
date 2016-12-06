//
//  GameplayScene.swift
//  jackTheGiant
//
//  Created by Leon on 6/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var center: CGFloat?
    var player: Player?
    
    var canMove = false
    var moveLeft = false
    
    override func didMove(to view: SKView) {
        center = (self.scene?.size.width)! / (self.scene?.size.height)!
        player = self.childNode(withName: "Player") as? Player!
        
        player?.initializePlayerAndAnimations()
    }
    
    override func update(_ currentTime: TimeInterval) {
        managePlayer()
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
}

