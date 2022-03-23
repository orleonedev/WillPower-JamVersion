//
//  WPHitState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPHitState: WPHealthState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPDefeatedState.Type || stateClass is WPInvulnerableState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("HitState")
        if let component = entity.component(ofType: WPHealthComponent.self) {
            component.heartCounter -= 1
            print("** remaining Heart: \(component.heartCounter)")
            if component.heartCounter <= 0 {
                self.stateMachine?.enter(WPDefeatedState.self)
            }
            else {
                self.stateMachine?.enter(WPInvulnerableState.self)
            }
            
        }
    }
}
