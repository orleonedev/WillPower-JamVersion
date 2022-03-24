//
//  Game.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import Foundation
import SpriteKit
import GameplayKit

enum Directions {
    case Up, Right, Down, Left
}

struct PhysicsCategory {
    static let none     : UInt32 = 0
    static let all      : UInt32 = UInt32.max
    static let player   : UInt32 = 0b1
    static let shield   : UInt32 = 0b10
    static let projectile: UInt32 = 0b100
    static let enemy:       UInt32 = 0b1000
}

class WPGame: NSObject, SceneDelegate, SKPhysicsContactDelegate {
    
    let swipeRightRecog = UISwipeGestureRecognizer()
    let swipeLeftRecog = UISwipeGestureRecognizer()
    let swipeUpRecog = UISwipeGestureRecognizer()
    let swipeDownRecog = UISwipeGestureRecognizer()
    
    private var _scene: WPScene?
    var random: GKGaussianDistribution
    var LevelStateMachine: GKStateMachine?
    var ignoreContacts: Bool = false
    
    
    //    var level: WPLevel
    var enemy: WPEntity
    var player: WPEntity
    var shield: WPEntity
    var pointsLabel: SKLabelNode?
    
    var score: Int = 0 {
        willSet {
            pointsLabel?.text = String(format: "%.6d", newValue)
        }
    }
    
    var blockCounter = 0 {
        willSet{
            switch newValue {
            case 10:
                LevelStateMachine?.enter(WP2XStreakState.self)
            case 20:
                LevelStateMachine?.enter(WP3XStreakState.self)
            case 30:
                LevelStateMachine?.enter(WP4XStreakState.self)
            case 0:
                LevelStateMachine?.enter(WPBaseStreakState.self)
            default:
                break
            }
        }
    }
    var multiplyer: Int = 1
    var prevUpdateTime: TimeInterval = 0
    
//    var shieldDirection: Directions {
//        get {
//            //            if let component = player.component(ofType: AAPLPlayerControlComponent.self) {
//            //                return component.direction
//            //            else {}
//            return .Down
//        }
//        set {
//            //            if let component = player.component(ofType: AAPLPlayerControlComponent.self) {
//            //                component.attemptedDirection = newValue
//
//        }
//    }
    
    
    override init() {
        random = GKGaussianDistribution(randomSource: GKRandomSource(), mean: 1.0, deviation: 0.75)
        
        
        player = WPEntity()
        shield = WPEntity()
        enemy = WPEntity()
        super.init()
        
       
        let base = WPBaseStreakState(withGame: self)
        let double = WP2XStreakState(withGame: self)
        let triple = WP3XStreakState(withGame: self)
        let quadra = WP4XStreakState(withGame: self)
        let gameover = WPGameOverState(withGame: self)
        
        LevelStateMachine = GKStateMachine(states: [base,double,triple,quadra,gameover])
        LevelStateMachine?.enter(WPBaseStreakState.self)
        
        player.addComponent(WPSpriteComponent(withDefaultColor: SKColor.red))
        player.addComponent(WPHealthComponent(withGame: self, characterEnt: player, maxHearts: 3))
        
        
        
        
        shield.addComponent(WPSpriteComponent(withDefaultColor: SKColor.green))
        //        shield.addComponent(WPPlayerControlComponent())
        
        
        enemy.addComponent(WPSpriteComponent(withDefaultColor: SKColor.systemTeal))
        enemy.addComponent(WPHealthComponent(withGame: self, characterEnt: enemy, maxHearts: 69))
        enemy.addComponent(WPAttackComponent(withGame: self, target: player, attacker: enemy))
        
        
        
    }
    
    
    var scene: SKScene {
        get {
            if _scene == nil {
                _scene = WPScene()
                _scene!.sceneDelegate = self
                _scene!.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
                _scene!.physicsWorld.contactDelegate = self
            }
            
            return _scene!
        }
    }
    
    func update(currentTime: TimeInterval, forScene scene: SKScene) {
        // Track the time delta since the last update.
        if prevUpdateTime < 0 {
            prevUpdateTime = currentTime
        }
        
        let dt = currentTime - prevUpdateTime
        prevUpdateTime = currentTime
        
        // Track remaining time on the powerup.
        //        powerupTimeRemaining -= dt
        
        // Update components with the new time delta.
        //        intelligenceSystem.update(deltaTime: dt)
        player.update(deltaTime: dt)
        enemy.update(deltaTime: dt)
        
        
    }
    
    func didMoveToView(scene: WPScene, view: SKView) {
        
        swipeRightRecog.addTarget(self, action: #selector(WPGame.swipedRight))
        swipeRightRecog.direction = .right
        view.addGestureRecognizer(swipeRightRecog)
        
        swipeLeftRecog.addTarget(self, action: #selector(WPGame.swipedLeft))
        swipeLeftRecog.direction = .left
        view.addGestureRecognizer(swipeLeftRecog)
        
        swipeUpRecog.addTarget(self, action: #selector(WPGame.swipedUp))
        swipeUpRecog.direction = .up
        view.addGestureRecognizer(swipeUpRecog)
        
        swipeDownRecog.addTarget(self, action: #selector(WPGame.swipedDown))
        swipeDownRecog.direction = .down
        view.addGestureRecognizer(swipeDownRecog)
        
        
        scene.backgroundColor = SKColor.init(hue: 150.0/255.0, saturation: 0.8, brightness: 0.1, alpha: 1.0)
        let bgNode = SKSpriteNode(texture: SKTexture(imageNamed: "twinkletwinkle-1"), size: scene.size)
        bgNode.name = "bg"
        bgNode.position = center
        bgNode.zPosition = 0
        bgNode.run(SKAction(named: "twinkleBG")!)
        scene.addChild(bgNode)
        
        
        
        pointsLabel = SKLabelNode(text: String(format: "%.6d", score))
        pointsLabel?.fontName = "VT323-Regular.ttf"
        pointsLabel?.horizontalAlignmentMode = .right
        pointsLabel?.verticalAlignmentMode = .center
        
        pointsLabel?.position = CGPoint(x: topRight.x - 18 , y: topRight.y - 80)
        pointsLabel?.zPosition = 200
        
        scene.addChild(pointsLabel ?? SKLabelNode(text: String(format: "%.6d", 0)))
        
        let pointsBox = SKSpriteNode(texture: SKTexture(imageNamed: "uilight-1"), color: SKColor.black, size: CGSize(width: pointsLabel!.frame.width + 20 , height: pointsLabel!.frame.height + 20 ))
        pointsBox.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        pointsBox.position = CGPoint(x: pointsLabel!.position.x + 10 , y: pointsLabel!.position.y)
        pointsBox.zPosition = 190
        scene.addChild(pointsBox)

        
        if let playerComponent = player.component(ofType: WPSpriteComponent.self){
            let sprite = WPSpriteNode(texture: SKTexture(imageNamed: "idle down-1"),color: playerComponent.defaultColor ,size:CGSize(width: 64.0 , height: 64.0))
            sprite.owner = playerComponent
            sprite.position = CGPoint(x: center.x, y: center.y - 32.0)
            sprite.zPosition = 25
            
            let body = SKPhysicsBody(circleOfRadius: 32.0 )
            body.categoryBitMask = PhysicsCategory.player
            body.contactTestBitMask = PhysicsCategory.projectile
            body.collisionBitMask = PhysicsCategory.none
            
            sprite.physicsBody = body
            playerComponent.sprite = sprite
            player.position = sprite.position
            scene.addChild((playerComponent.sprite)!)
            
        }
        
        if let playerHealthComponent = player.component(ofType: WPHealthComponent.self){
            for i in 0..<playerHealthComponent.maxHearts {
                let sprite = WPSpriteNode(texture: SKTexture(imageNamed: "heart-1"), size: CGSize(width: 32.0, height: 32.0))
                sprite.position = CGPoint(x: (topLeft.x + CGFloat(32 * (i+1)) + CGFloat(4 * i)) , y: topLeft.y - 80.0)
                sprite.name = "Heart\(i)"
                sprite.zPosition = 200
                scene.addChild(sprite)
            }
        }
        
        if let enemyComponent = enemy.component(ofType: WPSpriteComponent.self){
            let sprite = WPSpriteNode(texture: SKTexture(imageNamed: "magello idle-1"), size:CGSize(width: 166.0 , height: 208.0))
            sprite.owner = enemyComponent
            sprite.position = CGPoint(x: center.x, y: center.y + 256.0)
            sprite.zPosition = 25
            
            
            let body = SKPhysicsBody(circleOfRadius: 104.0 )
            body.categoryBitMask = PhysicsCategory.enemy
            body.contactTestBitMask = PhysicsCategory.none
            body.collisionBitMask = PhysicsCategory.none
            
            sprite.physicsBody = body
            enemyComponent.sprite = sprite
            sprite.name = "magelloSprite"
            scene.addChild((enemyComponent.sprite)!)
            if let magello = scene.childNode(withName: "magelloSprite") as? WPSpriteNode {
                magello.run(SKAction(named: "magelloIdle")!)
            }
            let sequence = SKAction.sequence([
                SKAction.run {
                    let firstMessage = SKLabelNode(text: "Are you ready to die?")
                    firstMessage.name = "firstMessage"
                    firstMessage.fontName = "VT323-Regular.ttf"
                    firstMessage.horizontalAlignmentMode = .center
                    firstMessage.verticalAlignmentMode = .center
                    firstMessage.position = CGPoint(x: sprite.position.x, y: sprite.position.y - 128)
                    firstMessage.zPosition = 200
                    scene.addChild(firstMessage)
                    
                    let secondMessage = SKLabelNode(text: "Swipe to move shield direction")
                    secondMessage.fontName = "VT323-Regular.ttf"
                    secondMessage.name = "secondMessage"
                    secondMessage.horizontalAlignmentMode = .center
                    secondMessage.verticalAlignmentMode = .center
                    secondMessage.numberOfLines = 2
                    secondMessage.preferredMaxLayoutWidth = 256
                    
                    secondMessage.position = CGPoint(x: self.center.x, y: self.center.y - 148)
                    secondMessage.zPosition = 200
                    scene.addChild(secondMessage)
                    
                },
                SKAction.run {
                    if let mess = scene.childNode(withName: "firstMessage") as? SKLabelNode {
                        mess.run(SKAction.fadeOut(withDuration: 4.0))
                    }
                    if let mess2 = scene.childNode(withName: "secondMessage") as? SKLabelNode {
                        mess2.run(SKAction.fadeOut(withDuration: 4.0))
                    }
                    
                },
                    SKAction.run{
                        if let attackComp = self.enemy.component(ofType: WPAttackComponent.self){
                            attackComp.attackEnable = true
                        }
                    }
               
            ])
            scene.run(sequence)
        }
        
        let shieldRing = SKSpriteNode(texture: SKTexture(imageNamed: "UI section-detached"), color: .white, size: CGSize(width: 128.0, height: 128.0))
        shieldRing.position = player.position
        shieldRing.zPosition = 30
        shieldRing.name = "shieldRing"
        shieldRing.colorBlendFactor = 1.0
        scene.addChild(shieldRing)
        
        if let shieldComponent = shield.component(ofType: WPSpriteComponent.self){
            let sprite = WPSpriteNode(texture: SKTexture(imageNamed: "UI section-8"), size: CGSize(width: 128.0, height: 128.0))
            sprite.owner = shieldComponent
            sprite.anchorSprite = player.component(ofType: WPSpriteComponent.self)?.sprite
            let body = SKPhysicsBody(rectangleOf: CGSize(width: 80.0, height: 32.0))
            body.categoryBitMask = PhysicsCategory.shield
            body.contactTestBitMask = PhysicsCategory.projectile
            body.collisionBitMask = PhysicsCategory.none
            sprite.physicsBody = body
            sprite.zPosition = 50
            shieldComponent.sprite = sprite
            sprite.shieldUp()
            scene.addChild((shieldComponent.sprite)!)
            
        }
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var projNode: WPSpriteNode?
        var shieldNode: WPSpriteNode?
        var playerNode: WPSpriteNode?
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
            projNode = contact.bodyA.node as? WPSpriteNode
        } else if contact.bodyA.categoryBitMask == PhysicsCategory.shield {
            shieldNode = contact.bodyA.node as? WPSpriteNode
        } else {
            playerNode = contact.bodyA.node as? WPSpriteNode
        }
        
        if contact.bodyB.categoryBitMask == PhysicsCategory.projectile {
            projNode = contact.bodyB.node as? WPSpriteNode
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.shield {
            shieldNode = contact.bodyB.node as? WPSpriteNode
        } else {
            playerNode = contact.bodyB.node as? WPSpriteNode
        }
        
        if let player = playerNode, let proj = projNode {
            playerHitted(playerNode: player, projNode: proj)
        }else if let shield = shieldNode, let proj = projNode{
            shieldHitted(shieldNode: shield , projNode: proj)
            
        }
    }
    
    
    func playerHitted(playerNode: WPSpriteNode, projNode: WPSpriteNode){
        projNode.removeAllActions()
        let crash = SKAction(named: "cometCollide")!
        let sequence = SKAction.sequence([crash, SKAction.run {
            projNode.removeFromParent()
        }])
        projNode.run(sequence)
        
        
        if !ignoreContacts{
            let player = playerNode.owner?.entity
            if let healthComponent = player?.component(ofType: WPHealthComponent.self){
                healthComponent.healthStateMachine.enter(WPHitState.self)
                
            }
        }
    }
    
    func shieldHitted(shieldNode: WPSpriteNode, projNode: WPSpriteNode){
        projNode.removeAllActions()
        let crash = SKAction(named: "cometCollide")!
        let sequence = SKAction.sequence([crash, SKAction.run {
            projNode.removeFromParent()
        }])
        projNode.run(sequence)
        
        if !ignoreContacts {
            score += (1*multiplyer)
            blockCounter += 1
        }
    }
    
    func resetCounter(){
        blockCounter = 0
    }
    
    @objc func swipedRight(){
        
        print("Swiped Right")
        
        if let shield = self.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldRight()
          
        }
    }
    
    @objc func swipedLeft(){
        
        print("Swiped Left")
        
        if let shield = self.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldLeft()
           
        }
    }
    
    @objc func swipedUp(){
       
        print("Swiped Up")
        
        if let shield = self.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldUp()
          
        }
        
    }
    
    @objc func swipedDown(){
        
        print("Swiped Down")
        
        if let shield = self.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldDown()
            
        }
        
    }
    
    
}







extension WPGame {
    var center: CGPoint {
        get{
            return CGPoint(x: (self.scene.view?.center.x)!, y: (self.scene.view?.center.y)!)
        }
    }
    
    var topLeft: CGPoint{
        get {
            return CGPoint(x: (self.scene.view?.frame.minX)! , y: (self.scene.view?.frame.maxY)! )
        }
    }
    var topRight: CGPoint{
        get {
            return CGPoint(x: (self.scene.view?.frame.maxX)! , y: (self.scene.view?.frame.maxY)! )
        }
    }
    
    var BottomLeft: CGPoint{
        get {
            return CGPoint(x: (self.scene.view?.frame.minX)! , y: (self.scene.view?.frame.minY)! )
        }
    }
    var BottomRight: CGPoint{
        get {
            return CGPoint(x: (self.scene.view?.frame.maxX)! , y: (self.scene.view?.frame.minY)! )
        }
    }
    
}
