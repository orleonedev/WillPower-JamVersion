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
    let audioInstance = SKTAudio.sharedInstance()
    var isFirstTime: Bool = true
    
    var enemy: WPEntity
    var player: WPEntity
    var shield: WPEntity
    var pointsLabel: SKLabelNode?
    var retryButton: SKSpriteNode?
    var firstMessage: SKLabelNode
    var secondMessage: SKLabelNode
    
    var score: Int = 0 {
        willSet {
            pointsLabel?.text = String(format: "%.6d", newValue)
        }
    }
    var highestScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "highestScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "highestScore")
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
    var multiplier: Int = 1
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
        
        firstMessage = SKLabelNode(text: "Are you ready to die?")
        firstMessage.name = "firstMessage"
        firstMessage.fontName = "VT323-Regular"
        firstMessage.fontSize = 42.0
        firstMessage.horizontalAlignmentMode = .center
        firstMessage.verticalAlignmentMode = .center
        
        secondMessage = SKLabelNode(text: "  Swipe to move shield direction")
        secondMessage.fontName = "VT323-Regular"
        secondMessage.fontSize = 48.0
        secondMessage.name = "secondMessage"
        secondMessage.horizontalAlignmentMode = .center
        secondMessage.verticalAlignmentMode = .center
        secondMessage.numberOfLines = 2
        secondMessage.preferredMaxLayoutWidth = 320
        
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
        if blockCounter != 0 && blockCounter%100 == 0 {
            appearFaster()
        }
        player.update(deltaTime: dt)
        enemy.update(deltaTime: dt)
        
        
        
        
    }
    func appearFaster() {
    let label = SKLabelNode(text: "FASTER!")
    label.fontName = "VT323-Regular"
    label.fontSize = 42.0
    label.horizontalAlignmentMode = .left
    label.verticalAlignmentMode = .center
    label.position = CGPoint(x: (pointsLabel?.position.x)! , y: (pointsLabel?.position.y)! - 256 - 32)
    label.zPosition = 200
    label.alpha = 0
    scene.addChild(label)
    label.run(SKAction.sequence([SKAction(named: "streakAppear")!,
                                 SKAction.run {
        label.removeFromParent()
    }]))
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
        
        audioInstance.playBackgroundMusic("magello2.mp3")
        
        
        scene.backgroundColor = SKColor.init(hue: 150.0/255.0, saturation: 0.8, brightness: 0.1, alpha: 1.0)
        let bgNode = SKSpriteNode(texture: SKTexture(imageNamed: "twinkletwinkle-1"), size: scene.size)
        bgNode.name = "bg"
        bgNode.position = center
        bgNode.zPosition = 0
        bgNode.run(SKAction(named: "twinkleBG")!)
        scene.addChild(bgNode)
        
        
        
        pointsLabel = SKLabelNode(text: String(format: "%.6d", score))
        pointsLabel?.fontName = "VT323-Regular"
        pointsLabel?.fontSize = 48
        pointsLabel?.horizontalAlignmentMode = .left
        pointsLabel?.verticalAlignmentMode = .top
        
        pointsLabel?.position = CGPoint(x: topLeft.x + 18 , y: topLeft.y - 64)
        pointsLabel?.zPosition = 200
        
        scene.addChild(pointsLabel ?? SKLabelNode(text: String(format: "%.6d", 0)))
        
        let pointsBox = SKSpriteNode(texture: SKTexture(imageNamed: "uilight-1"), color: SKColor.black, size: CGSize(width: pointsLabel!.frame.width + 20 , height: pointsLabel!.frame.height + 20 ))
        pointsBox.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        pointsBox.position = CGPoint(x: pointsLabel!.position.x - 10 , y: pointsLabel!.position.y+9)
        pointsBox.zPosition = 190
        scene.addChild(pointsBox)
        
       
        
        retryButton = SKSpriteNode(texture: SKTexture(imageNamed: "quardatorestart-1") ,color: SKColor.white, size: CGSize(width: 64, height: 64 ))
        retryButton?.name = "retry"
        retryButton?.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        retryButton?.position = CGPoint(x: topRight.x - 8.0,y: topRight.y - 60)
        retryButton?.zPosition = 200
        scene.addChild(retryButton!)
        
        let retryBox = SKSpriteNode(texture: SKTexture(imageNamed: "quadratone"), color: SKColor.blue, size: CGSize(width: 64, height: 64 ))
        retryBox.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        retryBox.position = CGPoint(x: retryButton!.position.x, y: retryButton!.position.y)
        retryBox.zPosition = 190
        scene.addChild(retryBox)
        
        
        let pillar = SKSpriteNode(texture: SKTexture(imageNamed: "pillar"), color: .brown, size: CGSize(width: 64 + 8, height: 64 + 8))
        pillar.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        pillar.position = CGPoint(x: center.x, y: center.y - 32.0)
        pillar.zPosition = 20
        scene.addChild(pillar)
        

        
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
                sprite.position = CGPoint(x: (topLeft.x + CGFloat(32 * (i+1)) + CGFloat(4 * i)) , y: pointsBox.position.y-72)
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
            
        }
        
        let shieldRing = SKSpriteNode(texture: SKTexture(imageNamed: "UI section-detached"), color: .gray, size: CGSize(width: 128.0, height: 128.0))
        shieldRing.position = player.position
        shieldRing.zPosition = 30
        shieldRing.name = "shieldRing"
        shieldRing.alpha = 0.6
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
        
        firstMessage.position = CGPoint(x: center.x, y: center.y + 128 - 32)
        firstMessage.zPosition = 200
        self.scene.addChild(firstMessage)
        
        secondMessage.position = CGPoint(x: self.center.x, y: self.center.y - 128 - 32)
        secondMessage.zPosition = 200
        self.scene.addChild(secondMessage)
        
        if isFirstTime {
            let overlay = SKSpriteNode(color: SKColor.black, size: (scene.size))
            overlay.position = center
            overlay.alpha = 0.6
            overlay.name = "overlayFirst"
            overlay.zPosition = 500
            
            let block = SKSpriteNode(texture: SKTexture(imageNamed: "quadratone"), color: SKColor.blue, size: CGSize(width: 352 + 32, height: 352 + 128))
            block.position = overlay.position
            block.alpha = 1.0
            block.name = "firstTime"
            block.zPosition = 525
            
            let willPower = SKLabelNode(text: "WillPower")
            willPower.position = CGPoint(x: block.position.x, y: block.position.y+128)
            willPower.fontSize = 64 + 16
            willPower.fontName = "VT323-Regular"
            willPower.name = "title"
            willPower.zPosition = 550
            willPower.fontColor = SKColor(hue: 143/360, saturation: 28/100, brightness: 65/100, alpha: 1.0)
            
            let press = SKLabelNode(text: "tap anywhere to start")
            press.position = CGPoint(x: block.position.x, y: block.position.y-128)
            press.fontSize = 32
            press.fontName = "VT323-Regular"
            press.name = "press"
            press.zPosition = 550
            
            
            let highScoreLabel = SKLabelNode(text: "HIGHSCORE: \(String(format: "%.6d", highestScore))")
            highScoreLabel.fontName = "VT323-Regular"
            highScoreLabel.fontSize = 46.0
            highScoreLabel.name = "highScoreFirst"
            highScoreLabel.position = CGPoint(x: block.position.x, y: block.position.y)
            highScoreLabel.zPosition = 550
            
            scene.addChild(overlay)
            scene.addChild(block)
            scene.addChild(willPower)
            scene.addChild(press)
            scene.addChild(highScoreLabel)
            
            

        }else{
            start()
        }
        
    }
    
    func start() {
        //self.isFirstTime = false
        let sequence = SKAction.sequence([
            SKAction.run {
                if let overlay = self.scene.childNode(withName: "overlayFirst") as? SKSpriteNode {
                    overlay.run(SKAction.fadeOut(withDuration: 1.0))
                    
                }
                if let block = self.scene.childNode(withName: "firstTime") as? SKSpriteNode {
                    block.run(SKAction.fadeOut(withDuration: 1.0))
                    
                }
                if let willPower = self.scene.childNode(withName: "title") as? SKLabelNode {
                    willPower.run(SKAction.fadeOut(withDuration: 1.0))
                    
                }
                if let press = self.scene.childNode(withName: "press") as? SKLabelNode {
                    press.run(SKAction.fadeOut(withDuration: 1.0))
                    
                }
                if let high = self.scene.childNode(withName: "highScoreFirst") as? SKLabelNode {
                    high.run(SKAction.fadeOut(withDuration: 1.0))
                    
                }
            },
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                if let overlay = self.scene.childNode(withName: "overlayFirst") as? SKSpriteNode {
                    
                    overlay.removeFromParent()
                }
                if let block = self.scene.childNode(withName: "firstTime") as? SKSpriteNode {
                    
                    block.removeFromParent()
                }
                if let willPower = self.scene.childNode(withName: "title") as? SKLabelNode {
                    willPower.removeFromParent()
                    
                }
                if let press = self.scene.childNode(withName: "press") as? SKLabelNode {
                    press.removeFromParent()
                    
                }
                if let high = self.scene.childNode(withName: "highScoreFirst") as? SKLabelNode {
                    high.removeFromParent()
                    
                }

                if let mess = self.scene.childNode(withName: "firstMessage") as? SKLabelNode {
                    mess.run(SKAction.fadeOut(withDuration: 2.0))
                }
                if let mess2 = self.scene.childNode(withName: "secondMessage") as? SKLabelNode {
                    mess2.run(SKAction.fadeOut(withDuration: 2.0))
                }
                
            },
                SKAction.run{
                    if let attackComp = self.enemy.component(ofType: WPAttackComponent.self){
                        attackComp.attackEnable = true
                    }
                }
           
        ])
        self.scene.run(sequence)
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
            score += (1*multiplier)
            blockCounter += 1
        }
    }
    
    func resetCounter(){
        blockCounter = 0
    }
    
    @objc func swipedRight(){
        
        print("Swiped Right")
        audioInstance.playSoundEffect("swosh.mp3")
        //audioInstance.soundEffectPlayer?.setVolume(0.1, fadeDuration: 0.1)
        if let shield = self.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldRight()
          
        }
    }
    
    @objc func swipedLeft(){
        
        print("Swiped Left")
        audioInstance.playSoundEffect("swosh.mp3")
       // audioInstance.soundEffectPlayer?.setVolume(0.1, fadeDuration: 0.1)
        if let shield = self.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldLeft()
           
        }
    }
    
    @objc func swipedUp(){
       
        print("Swiped Up")
        audioInstance.playSoundEffect("swosh.mp3")
        //audioInstance.soundEffectPlayer?.setVolume(0.1, fadeDuration: 0.1)
        if let shield = self.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldUp()
          
        }
        
    }
    
    @objc func swipedDown(){
        
        print("Swiped Down")
        audioInstance.playSoundEffect("swosh.mp3")
        //audioInstance.soundEffectPlayer?.setVolume(0.1, fadeDuration: 0.1)
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
