//
//  Player.swift
//  jackTheGiant
//
//  Created by Leon on 6/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    private var textureAtlas = SKTextureAtlas()
    private var playerAnimation = [SKTexture]()
    private var animatePlayerAction = SKAction()
    
    var lastY = CGFloat();
    
    func initializePlayerAndAnimations() {
        
        // Init Player Texture
        self.texture = SKTexture(imageNamed: "Player 1")
        self.size = (self.texture?.size())!
        
        // Init Player Physics
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width - 50, height: self.size.height - 5));
        self.physicsBody?.affectedByGravity = true;
        self.physicsBody?.allowsRotation = false; // don't rotate near the edge
        self.physicsBody?.restitution = 0; // don't bounce player
        self.physicsBody?.categoryBitMask = ColliderType.PLAYER;
        self.physicsBody?.collisionBitMask = ColliderType.CLOUD;
        self.physicsBody?.contactTestBitMask = ColliderType.DARK_CLOUD_AND_COLLECTABLES;

        // Init Animations
        textureAtlas = SKTextureAtlas(named: "Player.atlas")
        
        for i in 2...textureAtlas.textureNames.count {
            let name = "Player \(i)"
            playerAnimation.append(SKTexture(imageNamed: name))
        }
        
        // Save SKAction for animation
        animatePlayerAction = SKAction.animate(with: playerAnimation, timePerFrame: 0.05, resize: true, restore: false)
        
    }
    
    /// Run SKAction with Animation and direction
    ///
    /// - Parameter isMovingLeft: Changes xScale
    func animatePlayer(_ isMovingLeft: Bool) {
        
        if isMovingLeft {
            self.xScale = -fabs(self.xScale)
        } else {
            self.xScale = fabs(self.xScale)
        }
        
        self.run(SKAction.repeatForever(animatePlayerAction), withKey: "Animate")
    }
    
    func stopPlayerAnimation() {
        self.removeAction(forKey: "Animate")
        
        // Reset
        self.texture = SKTexture(imageNamed: "Player 1")
        self.size = (self.texture?.size())!
    }

    func movePlayer(_ isMovingLeft: Bool) {
        if isMovingLeft {
            self.position.x -= 7
        } else {
            self.position.x += 7
        }
    }
    
    /// Add score if player moves down
    func setScore() {
        if self.position.y < lastY {
            GameplayController.instance.incrementScore();
            lastY = self.position.y;
        }
    }

}
