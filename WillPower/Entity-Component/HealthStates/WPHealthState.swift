//
//  WPDefendState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPHealthState: GKState {
    weak var game: WPGame?
    var entity: WPEntity
    
    init(withGame: WPGame, entity: WPEntity) {
        self.game = withGame
        self.entity = entity
        
        super.init()
    }
}
