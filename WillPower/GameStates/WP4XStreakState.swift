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
        let label = SKLabelNode(text: "YOU'RE ON FIRE!")
        label.fontName = "VT323-Regular"
        label.fontSize = 42.0
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: (game?.pointsLabel?.position.x)! , y: (game?.pointsLabel?.position.y)! - 256 - 32 )
        label.zPosition = 200
        label.alpha = 0
        game?.scene.addChild(label)
        game?.multiplyer = 4
        label.run(SKAction.sequence([SKAction(named: "streakAppear")!,
                                     SKAction.run {
            label.removeFromParent()
        }]))
        if let scoreLabel = game?.pointsLabel {
            scoreLabel.fontColor = .orange
        }
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
