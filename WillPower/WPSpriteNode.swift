//
//  WPSpriteNode.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import SpriteKit

class WPSpriteNode: SKSpriteNode {
    weak var owner: WPSpriteComponent?
    
    func shieldBodyLeft() -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 32.0, height: 128.0), center: CGPoint(x: -48.0, y: 0.0))
        
        body.categoryBitMask = PhysicsCategory.shield
        body.contactTestBitMask = PhysicsCategory.projectile
        body.collisionBitMask = PhysicsCategory.none
        
        return body
    }
    
    func shieldBodyUp() -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 128.0, height: 32.0), center: CGPoint(x: 0.0, y: 48.0))
        
        body.categoryBitMask = PhysicsCategory.shield
        body.contactTestBitMask = PhysicsCategory.projectile
        body.collisionBitMask = PhysicsCategory.none
        
        return body
    }
    func shieldBodyDown() -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 128.0, height: 32.0), center: CGPoint(x: 0.0, y: -48.0))
        
        body.categoryBitMask = PhysicsCategory.shield
        body.contactTestBitMask = PhysicsCategory.projectile
        body.collisionBitMask = PhysicsCategory.none
        
        return body
    }
    func shieldBodyRight() -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 32.0, height: 128.0), center: CGPoint(x: 48.0, y: 0.0))
        
        body.categoryBitMask = PhysicsCategory.shield
        body.contactTestBitMask = PhysicsCategory.projectile
        body.collisionBitMask = PhysicsCategory.none
        
        return body
    }
}
