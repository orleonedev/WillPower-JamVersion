//
//  WPBaseStreakState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPBaseStreakState: WPGameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPGameOverState.Type || stateClass is WP2XStreakState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Base Streak")
        if let playerHealthComponent = game?.player.component(ofType: WPHealthComponent.self) {
            if playerHealthComponent.heartCounter <= 0 {
                self.stateMachine?.enter(WPGameOverState.self)
            }
        }
        game?.multiplyer = 1
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
