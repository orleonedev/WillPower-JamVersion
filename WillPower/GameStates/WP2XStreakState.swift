//
//  WP2XStreakState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WP2XStreakState: WPGameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPBaseStreakState.Type || stateClass is WP3XStreakState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("2x Streak Good Job!")
        game?.multiplyer = 2
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
