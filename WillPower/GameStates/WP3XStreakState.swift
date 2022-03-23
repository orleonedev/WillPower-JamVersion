//
//  WP3XStreakState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WP3XStreakState: WPGameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPBaseStreakState.Type || stateClass is WP4XStreakState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("3x Streak wow man Sfizioso")
        game?.multiplyer = 3
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
