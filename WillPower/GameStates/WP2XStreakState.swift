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
        label.fontName = "VT323-Regular.ttf"
        label.horizontalAlignmentMode = .right
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: (game?.pointsLabel?.position.x)! , y: (game?.pointsLabel?.position.y)! - 72)
        label.zPosition = 200
        label.alpha = 0
        game?.scene.addChild(label)
        game?.multiplyer = 2
        label.run(SKAction.sequence([SKAction(named: "streakAppear")!,
                                     SKAction.run {
            label.removeFromParent()
        }]))
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
