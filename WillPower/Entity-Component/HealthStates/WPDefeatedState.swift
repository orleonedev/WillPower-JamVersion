//
//  WPDefeatedState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPDefeatedState: WPHealthState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Defeated State")
        if let spriteComponent = entity.component(ofType: WPSpriteComponent.self){
            spriteComponent.pulseEffectEnabled = false
            spriteComponent.sprite?.colorBlendFactor = 0.0
            spriteComponent.sprite?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),      SKAction.run {
                self.game?.LevelStateMachine?.enter(WPGameOverState.self)
            }]))
            
        }
        
    }
}
