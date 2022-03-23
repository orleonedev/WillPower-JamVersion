//
//  WPDefendState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPDefendState: WPHealthState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPHitState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Defend State")
    }
}
