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
    
    func initializePlayerAndAnimations() {
        textureAtlas = SKTextureAtlas(named: "Player.atlas")
        
        for i in 2...textureAtlas.textureNames.count {
            let name = "Player \(i)"
            playerAnimation.append(SKTexture(imageNamed: name))
        }
        
        animatePlayerAction = SKAction.animate(with: playerAnimation, timePerFrame: 0.05, resize: true, restore: false)
        
        // Initial
        self.texture = SKTexture(imageNamed: "Player 1")
        self.size = (self.texture?.size())!
        
        // Physics
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width - 50, height: self.size.height - 5));
        self.physicsBody?.affectedByGravity = true;
        self.physicsBody?.allowsRotation = false; // don't rotate near the edge
        self.physicsBody?.restitution = 0; // don't bounce player
        self.physicsBody?.categoryBitMask = ColliderType.PLAYER;
        self.physicsBody?.collisionBitMask = ColliderType.CLOUD;
        self.physicsBody?.contactTestBitMask = ColliderType.DARK_CLOUD_AND_COLLECTABLES;

    }
    
    func animatePlayer(_ moveLeft: Bool) {
        
        if moveLeft {
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

    func movePlayer(_ moveLeft: Bool) {
        if moveLeft {
            self.position.x -= 7
        } else {
            self.position.x += 7
        }
    }
}
