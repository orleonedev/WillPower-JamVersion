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
        let label = SKLabelNode(text: "Good Job!")
        label.fontName = "VT323-Regular"
        label.fontSize = 42.0
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: (game?.pointsLabel?.position.x)! , y: (game?.pointsLabel?.position.y)! - 256 - 32)
        label.zPosition = 200
        label.alpha = 0
        game?.scene.addChild(label)
        game?.multiplier = 2
        label.run(SKAction.sequence([SKAction(named: "streakAppear")!,
                                     SKAction.run {
            label.removeFromParent()
        }]))
        
        if let scoreLabel = game?.pointsLabel {
            scoreLabel.fontColor = .green
        }
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
