//
//  GameState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import SpriteKit
import GameplayKit

class WPGameState: GKState {
    
    weak var game: WPGame?
    
    init(withGame: WPGame) {
        self.game = withGame
        
        
        super.init()
    }
    
}
