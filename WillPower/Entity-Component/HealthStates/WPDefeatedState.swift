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
        game?.LevelStateMachine?.enter(WPGameOverState.self)
    }
}
