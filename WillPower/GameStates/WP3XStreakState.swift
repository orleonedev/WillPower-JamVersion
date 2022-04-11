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
        let label = SKLabelNode(text: "Sfizioso!")
        label.fontName = "VT323-Regular"
        label.fontSize = 42.0
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: (game?.pointsLabel?.position.x)! , y: (game?.pointsLabel?.position.y)! - 256 - 32 )
        label.zPosition = 200
        label.alpha = 0
        game?.scene.addChild(label)
        game?.multiplier = 3
        label.run(SKAction.sequence([SKAction(named: "streakAppear")!,
                                     SKAction.run {
            label.removeFromParent()
        }]))
        
        if let scoreLabel = game?.pointsLabel {
            scoreLabel.fontColor = .yellow
        }
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
