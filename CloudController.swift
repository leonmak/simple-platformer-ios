//
//  CloudController.swift
//  jackTheGiant
//
//  Created by Leon on 7/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class CloudsController {
    
    var lastCloudPositionY = CGFloat()
    
    func createClouds() -> [SKSpriteNode] {
        var clouds = [SKSpriteNode]()
        
        for _ in 0...2 {
            let cloud1 = SKSpriteNode(imageNamed: "Cloud 1")
            let cloud2 = SKSpriteNode(imageNamed: "Cloud 2")
            let cloud3 = SKSpriteNode(imageNamed: "Cloud 3")
            let darkCloud = SKSpriteNode(imageNamed: "Dark Cloud")

            // To reference sprite later
            cloud1.name = "1"
            cloud2.name = "2"
            cloud3.name = "3"
            darkCloud.name = "Dark Cloud"
            
            cloud1.xScale = 0.9
            cloud1.yScale = 0.9
            cloud2.xScale = 0.9
            cloud2.yScale = 0.9
            cloud3.xScale = 0.9
            cloud3.yScale = 0.9
            darkCloud.xScale = 0.9
            darkCloud.yScale = 0.9
            
            // add physics bodies to clouds
            cloud1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cloud1.size.width - 5, height: cloud1.size.height - 6)) // resize physics body bounds
            cloud1.physicsBody?.affectedByGravity = false
            cloud1.physicsBody?.restitution = 0 // don't bounce on clouds
            cloud1.physicsBody?.categoryBitMask = ColliderType.CLOUD
            cloud1.physicsBody?.collisionBitMask = ColliderType.PLAYER
            
            cloud2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cloud2.size.width - 5, height: cloud2.size.height - 6))
            cloud2.physicsBody?.affectedByGravity = false
            cloud2.physicsBody?.restitution = 0
            cloud2.physicsBody?.categoryBitMask = ColliderType.CLOUD
            cloud2.physicsBody?.collisionBitMask = ColliderType.PLAYER
            
            cloud3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cloud3.size.width - 5, height: cloud3.size.height - 6))
            cloud3.physicsBody?.affectedByGravity = false
            cloud3.physicsBody?.restitution = 0
            cloud3.physicsBody?.categoryBitMask = ColliderType.CLOUD
            cloud3.physicsBody?.collisionBitMask = ColliderType.PLAYER
            
            darkCloud.physicsBody = SKPhysicsBody(rectangleOf: darkCloud.size)
            darkCloud.physicsBody?.affectedByGravity = false
            darkCloud.physicsBody?.categoryBitMask = ColliderType.DARK_CLOUD_AND_COLLECTABLES
            darkCloud.physicsBody?.collisionBitMask = ColliderType.PLAYER
            
            clouds.append(cloud1)
            clouds.append(cloud2)
            clouds.append(cloud3)
            clouds.append(darkCloud)

        }
        
        clouds = shuffle(cloudsArray: clouds)
        return clouds
    }
    
    func arrangeCloudsInScene(scene: SKScene, distaneBetweenClouds: CGFloat, center: CGFloat, minX: CGFloat, maxX: CGFloat, player: Player, initialClouds: Bool) {
        
        var clouds = createClouds()
        
        if initialClouds {
            while(clouds[0].name == "Dark Cloud") {
                clouds = shuffle(cloudsArray: clouds)
            }
        }
        
        var positionY = CGFloat()
        
        if initialClouds {
            positionY = center - 100
        } else {
            positionY = lastCloudPositionY
        }
        
        var random = 0
        
        for i in 0..<clouds.count {
            
            var randomX = CGFloat()
            
            // put cloud on right side
            if random == 0 {
                randomX = randomBetweenNumbers(firstNum: center + 90, secondNum: maxX)
                random = 1 // next put on left side
            } else {
                randomX = randomBetweenNumbers(firstNum: center - 90, secondNum: minX)
                random = 0
            }
            
            clouds[i].position = CGPoint(x: randomX, y: positionY)
            clouds[i].zPosition = 3 // above background
            
            if !initialClouds {
                if Int(randomBetweenNumbers(firstNum: 0, secondNum: 7)) >= 3 {
                    if clouds[i].name != "Dark Cloud" {
                    }
                    
                }
            }
            
            scene.addChild(clouds[i])
            positionY -= distaneBetweenClouds
            lastCloudPositionY = positionY
            
            if initialClouds {
                player.position = CGPoint(x: clouds[0].position.x, y: clouds[0].position.y + 9)
            }
            
        }
        
    }
    
    
    private func shuffle(cloudsArray: [SKSpriteNode]) -> [SKSpriteNode] {
        
        var shuffledArray = cloudsArray
        for i in 0..<shuffledArray.count {
            let j = Int(arc4random_uniform(UInt32(shuffledArray.count - i))) + i
            if i == j {continue}
            swap(&shuffledArray[i], &shuffledArray[j])
        }
        
        return shuffledArray
    }
    
    private func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }

}
