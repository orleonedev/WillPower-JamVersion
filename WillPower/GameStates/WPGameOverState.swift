//
//  WPGameOverState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPGameOverState: WPGameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPBaseStreakState.Type
        
    }
    
    override func didEnter(from previousState: GKState?) {
        print("GameOver")
        game?.scene.isPaused = true
        
    }
    
    override func willExit(to nextState: GKState) {
        game?.scene.isPaused = false
        game?.score = 0
    }
    
    
    
    
}
