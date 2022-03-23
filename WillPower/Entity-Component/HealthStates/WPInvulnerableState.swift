//
//  WPInvulnerableState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPInvulnerableState: WPHealthState {
    
    var duration: TimeInterval = 2.0
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPDefendState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("invulnerable state")
        duration = 2.0
        
        if let spriteComponent = entity.component(ofType: WPSpriteComponent.self){
            spriteComponent.pulseEffectEnabled = true
            spriteComponent.sprite?.colorBlendFactor = 0.8
            game?.ignoreContacts = true
            
        }
    }
    
    override func willExit(to nextState: GKState) {
        if let spriteComponent = entity.component(ofType: WPSpriteComponent.self){
            spriteComponent.pulseEffectEnabled = false
            spriteComponent.sprite?.colorBlendFactor = 0.0
            game?.ignoreContacts = false
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.duration -= seconds
        if self.duration < 0 {
            stateMachine?.enter(WPDefendState.self)
        }
    }
    
}
