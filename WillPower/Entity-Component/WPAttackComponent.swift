//
//  WPAttackComponent.swift
//  WillPower
//
//  Created by Oreste Leone on 23/03/22.
//

import GameplayKit

class WPAttackComponent: GKComponent {
    
    var secondRandom: GKGaussianDistribution
    var seed: GKRandomSource = GKRandomSource()
    var divider: Double = 1.0
    var randomDir: GKRandomDistribution
    var target: WPEntity
    var game: WPGame
    var attacker: WPEntity
    var frequencyRange: SKRange {
        get{
            return SKRange(lowerLimit: (0.0 * CGFloat(game.multiplier*game.multiplier)), upperLimit: (3.0 * CGFloat(game.multiplier)))
        }
    }
    var velocity: TimeInterval = 1.0
    var timeSpan: TimeInterval = 1.0
    var remainingTime: TimeInterval = 3.0
    var attackEnable: Bool = false
      
    init (withGame: WPGame, target: WPEntity, attacker: WPEntity) {
        self.game = withGame
        self.target = target
        self.attacker = attacker
        randomDir = GKRandomDistribution(forDieWithSideCount: 4)
        secondRandom = GKGaussianDistribution()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if game.blockCounter != 0 && game.blockCounter%100 == 0 {
            if velocity > 0.6 {
                velocity -= 0.1
                game.blockCounter += 1
            }
        }else if game.blockCounter == 0 {
            velocity = 1.0
        }
        
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
                
                secondRandom = GKGaussianDistribution(randomSource: seed , lowestValue: 1*game.multiplier/2, highestValue: 2*game.multiplier - (game.multiplier/2))
                divider = Double(secondRandom.nextInt())
                print("seed: \(divider)")
                remainingTime = timeSpan * TimeInterval(1.0 / (divider + 1.0)) + 0.15
                print(remainingTime)
//            remainingTime = timeSpan * TimeInterval( 1.0 / (Double(game.random.nextInt(upperBound: Int(frequencyRange.upperLimit))) + 1.0))
            
            
        }
            
        }
        }
        
    }
    
    func shoot(from: Directions) {
        
        let offset = randomOffset()
        let projectile = WPSpriteNode(texture: SKTexture(imageNamed: "comet moving-1"), size: CGSize(width: 48.0, height: 48.0))
        projectile.zPosition = 50
        let body = SKPhysicsBody(circleOfRadius: 16.0 )
        body.categoryBitMask = PhysicsCategory.projectile
        body.contactTestBitMask = PhysicsCategory.player + PhysicsCategory.shield
        body.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody = body
        projectile.run(SKAction(named: "cometMoving")!)
        switch from {
        case .Up:
            projectile.position = CGPoint(x: game.player.position.x + offset, y: game.player.position.y + 168)
            projectile.zRotation = 89.55
            projectile.run(SKAction.moveTo(y: target.position.y, duration: velocity))
        case .Right:
            projectile.position = CGPoint(x: game.player.position.x + 168, y: game.player.position.y + offset )
            projectile.zRotation = 0
            projectile.run(SKAction.moveTo(x: target.position.x, duration: velocity))
        case .Down:
            projectile.position = CGPoint(x: game.player.position.x + offset, y: game.player.position.y - 168)
            projectile.zRotation = -89.55
            projectile.run(SKAction.moveTo(y: target.position.y, duration: velocity))
        case .Left:
            projectile.position = CGPoint(x: game.player.position.x - 168, y: game.player.position.y + offset)
            projectile.zRotation = 179.1
            projectile.run(SKAction.moveTo(x: target.position.x, duration: velocity))
        }
        
        game.scene.addChild(projectile)
        
        
        
        
    }
    
    func randomOffset()-> CGFloat{
        let distribution = GKGaussianDistribution(forDieWithSideCount: 6)
        var offset: CGFloat
        switch distribution.nextInt(){
        case 1,5:
            offset = -20.0
        case 2,6:
            offset = 20.0
        default:
            offset = 0.0
        }
        
        return offset
        
    }
}
