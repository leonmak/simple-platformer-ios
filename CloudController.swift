//
//  CloudController.swift
//  jackTheGiant
//
//  Created by Leon on 7/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class CloudsController {
    
    let collectablesController = CollectablesController();
    var lastCloudPositionY = CGFloat()
    
    /// Adds 12 clouds and 0/12 collectables on scene
    func arrangeCloudsInScene(scene: SKScene, distaneBetweenClouds: CGFloat, center: CGFloat, minX: CGFloat, maxX: CGFloat, player: Player, initialClouds: Bool) {
        
        var clouds = createClouds()
        
        // Don't want initial cloud to be dark
        print(initialClouds)
        if initialClouds {
            while(clouds[0].name == "Dark Cloud") {
                clouds = shuffle(cloudsArray: clouds)
            }
            print("\(clouds[0].name)")
        }
        
        var positionY = CGFloat()
        
        // Manage y position of clouds
        if initialClouds {
            // First cloud slightly below center
            positionY = center - 100
        } else {
            // Next clouds get from previous call
            positionY = lastCloudPositionY
        }
        
        var random = 0
        
        for i in 0..<clouds.count {
            
            var randomX = CGFloat()
            
            // Put cloud on left side
            if random == 0 {
                randomX = randomBetweenNumbers(firstNum: center - 90, secondNum: minX)
                random = 1 // Next iter put on right side
            } else {
                randomX = randomBetweenNumbers(firstNum: center + 90, secondNum: maxX)
                random = 0
            }
            
            clouds[i].position = CGPoint(x: randomX, y: positionY)
            clouds[i].zPosition = 3
            
            // Put collectable on non-dark clouds after 1st bg
            if !initialClouds {
                if Int(randomBetweenNumbers(firstNum: 0, secondNum: 7)) >= 3 {
                    if clouds[i].name != "Dark Cloud" {
                        
                        // Add life,coin,empty to scene
                        let collectable = collectablesController.getCollectable();
                        collectable.position = CGPoint(x: clouds[i].position.x, y: clouds[i].position.y + 60);
                        scene.addChild(collectable);
                    }
                    
                }
            }
            
            // Add Cloud to scene
            scene.addChild(clouds[i])
            positionY -= distaneBetweenClouds
            lastCloudPositionY = positionY
            
            // Initialize player above first cloud
            if initialClouds {
                player.position = CGPoint(x: clouds[0].position.x, y: clouds[0].position.y + 9)
            }
        }
    }
    
    
    /// Creates 12 clouds, 4 Clouds each for BG 1, 2, 3
    ///
    /// - Returns: Array of clouds
    func createClouds() -> [SKSpriteNode] {
        var clouds = [SKSpriteNode]()
        
        // for 3 backgrounds
        for _ in 0..<3 {
            let darkCloud = SKSpriteNode(imageNamed: "Dark Cloud")
            
            // Name to reference sprite later
            darkCloud.name = "Dark Cloud"
            darkCloud.xScale = 0.9
            darkCloud.yScale = 0.9
            
            darkCloud.physicsBody = SKPhysicsBody(rectangleOf: darkCloud.size)
            darkCloud.physicsBody?.affectedByGravity = false
            darkCloud.physicsBody?.categoryBitMask = ColliderType.DARK_CLOUD_AND_COLLECTABLES
            darkCloud.physicsBody?.collisionBitMask = ColliderType.PLAYER
            
            clouds.append(darkCloud)
            
            // add physics bodies to 3 clouds
            for i in 1...3 {
                let cloud = SKSpriteNode(imageNamed: "Cloud \(i)")
                cloud.name = "\(i)"
                cloud.xScale = 0.9
                cloud.yScale = 0.9
                cloud.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cloud.size.width - 5, height: cloud.size.height - 6)) // resize physics body bounds
                cloud.physicsBody?.affectedByGravity = false
                cloud.physicsBody?.restitution = 0 // don't bounce on clouds
                cloud.physicsBody?.categoryBitMask = ColliderType.CLOUD
                cloud.physicsBody?.collisionBitMask = ColliderType.PLAYER
                clouds.append(cloud)
            }
        }
        
        return shuffle(cloudsArray: clouds)
    }
    
    private func shuffle(cloudsArray: [SKSpriteNode]) -> [SKSpriteNode] {
        // parameters are constants
        var cloudsArray = cloudsArray
        for i in 0..<cloudsArray.count {
            let j = Int(arc4random_uniform(UInt32( cloudsArray.count - i))) + i
            if i == j {continue}
            swap(&cloudsArray[i], &cloudsArray[j])
        }
        
        return cloudsArray
    }
    
    private func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }

}
