//
//  Player.swift
//  jackTheGiant
//
//  Created by Leon on 6/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    func movePlayer(_ moveLeft: Bool) {
        if moveLeft {
            self.position.x -= 7
        } else {
            self.position.x += 7
        }
    }
}
