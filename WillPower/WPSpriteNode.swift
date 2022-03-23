//
//  WPSpriteNode.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import SpriteKit

class WPSpriteNode: SKSpriteNode {
    weak var owner: WPSpriteComponent?
    var anchorSprite: WPSpriteNode?
    func shieldLeft() {
        self.position = CGPoint(x: (anchorSprite?.position.x ?? 0.0) - 52, y: (anchorSprite?.position.y ?? 0.0) )
        self.zRotation = 89.53
        anchorSprite?.run(SKAction(named: "shieldLeft")!)
    }
    
    func shieldUp() {
        self.position = CGPoint(x: (anchorSprite?.position.x ?? 0.0), y: (anchorSprite?.position.y ?? 0.0) + 52)
        self.zRotation = 0.0
        anchorSprite?.run(SKAction(named: "shieldUp")!)
    }
    func shieldDown() {
        self.position = CGPoint(x: (anchorSprite?.position.x ?? 0.0), y: (anchorSprite?.position.y ?? 0.0) - 52)
        self.zRotation = 179.075
        anchorSprite?.run(SKAction(named: "shieldDown")!)
    }
    func shieldRight() {
        self.position = CGPoint(x: (anchorSprite?.position.x ?? 0.0) + 52, y: (anchorSprite?.position.y ?? 0.0) )
        self.zRotation = -89.53
        anchorSprite?.run(SKAction(named: "shieldRight")!)
    }
    
}
