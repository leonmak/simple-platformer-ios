//
//  BGClass.swift
//  jackTheGiant
//
//  Created by Leon on 6/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import SpriteKit

class BGClass: SKSpriteNode {
    
    /// Once bg is out of camera position, shift it to the bottom
    func moveBG(_ camera: SKCameraNode) {
        if  self.position.y - self.size.height - 10 > camera.position.y {
            self.position.y -= self.size.height * 3
        }
    }
}
