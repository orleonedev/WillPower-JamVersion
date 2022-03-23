//
//  WP4XStreakState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WP4XStreakState: WPGameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPBaseStreakState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("4x Streak HOLY MOLY SHITTY MACARONI")
        game?.multiplyer = 4
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
