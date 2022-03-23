//
//  WPAttackComponent.swift
//  WillPower
//
//  Created by Oreste Leone on 23/03/22.
//

import GameplayKit

class WPAttackComponent: GKComponent {
    
    var randomDir: GKRandomDistribution
    var target: WPEntity
    var game: WPGame
    var attacker: WPEntity
    var frequencyRange: SKRange {
        get{
            return SKRange(lowerLimit: (0.0 * CGFloat(game.multiplyer*game.multiplyer)), upperLimit: (3.0 * CGFloat(game.multiplyer)))
        }
    }
    var timeSpan: TimeInterval = 1.0
    var remainingTime: TimeInterval = 5.0
    var attackEnable: Bool = false
      
    init (withGame: WPGame, target: WPEntity, attacker: WPEntity) {
        self.game = withGame
        self.target = target
        self.attacker = attacker
        randomDir = GKRandomDistribution(forDieWithSideCount: 4)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
       if attackEnable {
           self.remainingTime -= seconds
        
        if !game.ignoreContacts{
            if self.remainingTime < 0 {
            switch randomDir.nextInt(){
            case 1:
                shoot(from: .Left)
            case 2:
                shoot(from: .Right)
            case 3:
                shoot(from: .Down)
            default:
                shoot(from: .Up)
            }
            
            remainingTime = timeSpan * TimeInterval( 1.0 / (Double(game.random.nextInt(upperBound: Int(frequencyRange.upperLimit))) + 1.0))
            print(remainingTime)
            
        }
            
        }
        }
        
    }
    
    func shoot(from: Directions) {
        
        let projectile = WPSpriteNode(texture: SKTexture(imageNamed: "comet moving-1"), size: CGSize(width: 48.0, height: 48.0))
        switch from {
        case .Up:
            projectile.position = CGPoint(x: game.player.position.x, y: game.player.position.y + 168)
            projectile.zRotation = 89.55
        case .Right:
            projectile.position = CGPoint(x: game.player.position.x + 168, y: game.player.position.y )
            projectile.zRotation = 0
        case .Down:
            projectile.position = CGPoint(x: game.player.position.x, y: game.player.position.y - 168)
            projectile.zRotation = -89.55
        case .Left:
            projectile.position = CGPoint(x: game.player.position.x - 168, y: game.player.position.y)
            projectile.zRotation = 179.1
        }
        projectile.zPosition = 50
        let body = SKPhysicsBody(circleOfRadius: 16.0 )
        body.categoryBitMask = PhysicsCategory.projectile
        body.contactTestBitMask = PhysicsCategory.player + PhysicsCategory.shield
        body.collisionBitMask = PhysicsCategory.none
        
        projectile.physicsBody = body
        game.scene.addChild(projectile)
        projectile.run(SKAction(named: "cometMoving")!)
        projectile.run(SKAction.move(to: target.position, duration: 1.0))
        
        
        
    }
}
