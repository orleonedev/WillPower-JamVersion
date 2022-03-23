//
//  WPAttackComponent.swift
//  WillPower
//
//  Created by Oreste Leone on 23/03/22.
//

import GameplayKit

class WPAttackComponent: GKComponent {
    
    var target: WPEntity
    var game: WPGame
    var attacker: WPEntity
    var frequencyRange: SKRange {
        get{
            return SKRange(lowerLimit: (1.0 * CGFloat(game.multiplyer)), upperLimit: (5.0 * CGFloat(game.multiplyer)))
        }
    }
    var timeSpan: TimeInterval = 2.0
    var remainingTime: TimeInterval = 2.0
    
    init (withGame: WPGame, target: WPEntity, attacker: WPEntity) {
        self.game = withGame
        self.target = target
        self.attacker = attacker
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.remainingTime -= seconds
        if self.remainingTime < 0 {
            shoot(from: .Left)
            remainingTime = timeSpan
        }
        
        
    }
    
    func shoot(from: Directions) {
        
        let projectile = WPSpriteNode(color: SKColor.cyan, size: CGSize(width: 16.0, height: 16.0))
        switch from {
        case .Up:
            projectile.position = CGPoint(x: game.player.position.x, y: game.player.position.y + 144)
        case .Right:
            projectile.position = CGPoint(x: game.player.position.x + 144, y: game.player.position.y )
        case .Down:
            projectile.position = CGPoint(x: game.player.position.x, y: game.player.position.y - 144)
        case .Left:
            projectile.position = CGPoint(x: game.player.position.x - 144, y: game.player.position.y)
        }
        
        let body = SKPhysicsBody(circleOfRadius: 8.0 )
        body.categoryBitMask = PhysicsCategory.projectile
        body.contactTestBitMask = PhysicsCategory.player + PhysicsCategory.shield
        body.collisionBitMask = PhysicsCategory.none
        
        projectile.physicsBody = body
        game.scene.addChild(projectile)
        
        projectile.run(SKAction.move(to: target.position, duration: 1.0))
        
        
        
    }
}
