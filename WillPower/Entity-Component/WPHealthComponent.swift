//
//  WPHealthComponent.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPHealthComponent: GKComponent {
    
    var healthStateMachine: GKStateMachine
    
    var game: WPGame
    var char: WPEntity
    var maxHearts: Int
    var heartCounter: Int {
        willSet {
            game.resetCounter()
            game.scene.childNode(withName: "Heart\(heartCounter-1)")?.removeFromParent()
        }
    }
    
    init(withGame: WPGame, characterEnt: WPEntity, maxHearts: Int){
        self.game = withGame
        self.char = characterEnt
        self.maxHearts = maxHearts
        self.heartCounter = maxHearts
        
        let defend = WPDefendState(withGame: game, entity: char)
        let hit = WPHitState(withGame: game, entity: char)
        let defeated = WPDefeatedState(withGame: game, entity: char)
        let invulnerable = WPInvulnerableState(withGame: game, entity: char)
        healthStateMachine = GKStateMachine(states: [defend,hit,defeated,invulnerable])
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        healthStateMachine.update(deltaTime: seconds)
    }
}
