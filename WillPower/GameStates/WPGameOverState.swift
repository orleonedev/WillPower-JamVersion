//
//  WPGameOverState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPGameOverState: WPGameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPBaseStreakState.Type
        
    }
    
    override func didEnter(from previousState: GKState?) {
        print("GameOver")
        if let attComp = game?.enemy.component(ofType: WPAttackComponent.self){
            attComp.attackEnable = false
            game?.ignoreContacts = true
            
            let overlay = SKSpriteNode(color: SKColor.black, size: (game?.scene.size)!)
            overlay.position = game!.center
            overlay.alpha = 0.0
            overlay.name = "overlay"
            overlay.zPosition = 500
            
            let block = SKSpriteNode(texture: SKTexture(imageNamed: "quadratone"), color: SKColor.blue, size: CGSize(width: 256 + 64 + 32, height: 256 + 64 + 32))
            block.position = overlay.position
            block.alpha = 0.0
            block.name = "block"
            block.zPosition = 525
            
            let finalScore = SKLabelNode(text: String(format: "%.6d", game!.score))
            finalScore.fontSize = 64
            finalScore.name = "finalscore"
            finalScore.position = CGPoint(x: game!.center.x, y: game!.center.y + 64 + 32)
            finalScore.zPosition = 550
            finalScore.alpha = 0.0
            
            let retry = SKSpriteNode(color: SKColor.white, size: CGSize(width: 64 + 32, height: 64 + 32))
            retry.name = "retry"
            retry.position = game!.center
            retry.zPosition = 550
            retry.alpha = 0.0
            
            game?.scene.addChild(overlay)
            game?.scene.addChild(block)
            game?.scene.addChild(finalScore)
            game?.scene.addChild(retry)
            
            overlay.run(SKAction.fadeAlpha(to: 0.6, duration: 0.5 ))
            block.run(SKAction.fadeIn(withDuration: 0.5))
            retry.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5 ))
            finalScore.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5 ))
            
            
        }

    }
    
    override func willExit(to nextState: GKState) {

    }
    
}
