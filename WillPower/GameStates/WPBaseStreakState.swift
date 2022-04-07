//
//  WPBaseStreakState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPBaseStreakState: WPGameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPGameOverState.Type || stateClass is WP2XStreakState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Base Streak")
        if let playerHealthComponent = game?.player.component(ofType: WPHealthComponent.self) {
            if playerHealthComponent.heartCounter <= 0 {
                self.stateMachine?.enter(WPGameOverState.self)
            }
        }
        game?.multiplyer = 1
        if let scoreLabel = game?.pointsLabel {
            scoreLabel.fontColor = .white
        }
        
        if previousState is WP2XStreakState || previousState is WP3XStreakState || previousState is WP4XStreakState{
            let label = SKLabelNode(text: "Oh No!")
        label.fontName = "VT323-Regular"
        label.fontSize = 42.0
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: (game?.pointsLabel?.position.x)! , y: (game?.pointsLabel?.position.y)! - 256 - 32)
        label.zPosition = 200
        label.alpha = 0
        game?.scene.addChild(label)
        label.run(SKAction.sequence([SKAction(named: "streakAppear")!,
                                     SKAction.run {
            label.removeFromParent()
        }]))
            
        }
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
