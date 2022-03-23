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
}

class WPGame: NSObject, SceneDelegate, SKPhysicsContactDelegate {
    
    private var _scene: WPScene?
    var random: GKRandomSource
    var LevelStateMachine: GKStateMachine?
    var ignoreContacts: Bool = false
    
    
    //    var level: WPLevel
    var enemy: WPEntity
    var player: WPEntity
    var shield: WPEntity
    var pointsLabel: SKLabelNode?
    var score: Int = 0 {
        willSet {
            pointsLabel?.text = String(format: "%.8d", newValue)
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
        random = GKRandomSource()
        
        
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
        scene.backgroundColor = SKColor.gray
        
        pointsLabel = SKLabelNode(text: String(format: "%.8d", score))
        pointsLabel?.horizontalAlignmentMode = .right
        pointsLabel?.verticalAlignmentMode = .center
        pointsLabel?.position = CGPoint(x: topRight.x - 16 , y: topRight.y - 80)
        
        scene.addChild(pointsLabel ?? SKLabelNode(text: String(format: "%.8d", 0)))
        
        if let playerComponent = player.component(ofType: WPSpriteComponent.self){
            let sprite = WPSpriteNode(texture: SKTexture(imageNamed: "YamiIdle1"), size:CGSize(width: 64.0 , height: 64.0))
            sprite.owner = playerComponent
            sprite.position = CGPoint(x: center.x, y: center.y - 32.0)
            
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
                let sprite = WPSpriteNode(color: SKColor.red, size: CGSize(width: 32.0, height: 32.0))
                sprite.position = CGPoint(x: (topLeft.x + CGFloat(32 * (i+1)) + CGFloat(4 * i)) , y: topLeft.y - 80.0)
                sprite.name = "Heart\(i)"
                scene.addChild(sprite)
            }
        }
        
        if let enemyComponent = enemy.component(ofType: WPSpriteComponent.self){
            let sprite = WPSpriteNode(color: enemyComponent.defaultColor, size:CGSize(width: 128.0 , height: 128.0))
            sprite.owner = enemyComponent
            sprite.position = CGPoint(x: center.x, y: center.y + 208)
            
            
            let body = SKPhysicsBody(circleOfRadius: 64.0 )
            body.categoryBitMask = PhysicsCategory.player
            body.contactTestBitMask = PhysicsCategory.none
            body.collisionBitMask = PhysicsCategory.none
            
            sprite.physicsBody = body
            enemyComponent.sprite = sprite
            scene.addChild((enemyComponent.sprite)!)
        }
        
        if let shieldComponent = shield.component(ofType: WPSpriteComponent.self){
            let sprite = WPSpriteNode(texture: SKTexture(imageNamed: "strokes"), size: CGSize(width: 128.0, height: 128.0))
            sprite.owner = shieldComponent
            sprite.position = player.position
            
            sprite.physicsBody = sprite.shieldBodyDown()
            shieldComponent.sprite = sprite
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
        projNode.removeFromParent()
        
        if !ignoreContacts{
            let player = playerNode.owner?.entity
            if let healthComponent = player?.component(ofType: WPHealthComponent.self){
                healthComponent.healthStateMachine.enter(WPHitState.self)
                
            }
        }
    }
    
    func shieldHitted(shieldNode: WPSpriteNode, projNode: WPSpriteNode){
        projNode.removeFromParent()
        
        if !ignoreContacts {
            score += (1*multiplyer)
            blockCounter += 1
        }
    }
    
    func resetCounter(){
        blockCounter = 0
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
