//
//  WPGameOverState.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import GameplayKit

class WPGameOverState: WPGameState {
    
    var finalScore: SKLabelNode?
    var highScoreLabel: SKLabelNode?
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WPBaseStreakState.Type
        
    }
    
    override func didEnter(from previousState: GKState?) {
        print("GameOver")
        
        if let scoreValue = game?.score{
            finalScore = SKLabelNode(text: String(format: "%.6d", scoreValue))
            finalScore?.fontName = "VT323-Regular"
            finalScore?.fontSize = 64 + 16
            finalScore?.name = "finalscore"
            finalScore?.position = CGPoint(x: game!.center.x, y: game!.center.y + 64 + 32)
            finalScore?.zPosition = 550
            finalScore?.alpha = 0.0
            
            if let highScore = game?.highestScore {
                if scoreValue > highScore {
                    game?.highestScore = scoreValue
                }
            }
            
            if let newHighScore = game?.highestScore {
                highScoreLabel = SKLabelNode(text: "HIGH SCORE: \(String(format: "%.6d", newHighScore))")
                highScoreLabel?.fontName = "VT323-Regular"
                highScoreLabel?.fontSize = 42.0
                highScoreLabel?.name = "highScore"
                highScoreLabel?.position = CGPoint(x: game!.center.x, y: game!.center.y - 128 - 16)
                highScoreLabel?.zPosition = 550
                highScoreLabel?.alpha = 0.0
            }
            
        }
        
        if let attComp = game?.enemy.component(ofType: WPAttackComponent.self){
            attComp.attackEnable = false
            game?.ignoreContacts = true
            
            let overlay = SKSpriteNode(color: SKColor.black, size: (game?.scene.size)!)
            overlay.position = game!.center
            overlay.alpha = 0.0
            overlay.name = "overlay"
            overlay.zPosition = 500
            
            let block = SKSpriteNode(texture: SKTexture(imageNamed: "quadratone"), color: SKColor.blue, size: CGSize(width: 352 + 32, height: 352 + 32))
            block.position = overlay.position
            block.alpha = 0.0
            block.name = "block"
            block.zPosition = 525
            
            
            
            let retry = SKSpriteNode(texture: SKTexture(imageNamed: "quardatorestart-1") ,color: SKColor.white, size: CGSize(width: 264 - 48, height: 256 - 48 ))
            retry.name = "retry"
            retry.position = CGPoint(x: game!.center.x, y: game!.center.y - 8)
            retry.zPosition = 550
            retry.alpha = 0.0
            
            game?.scene.addChild(overlay)
            game?.scene.addChild(block)
            game?.scene.addChild(finalScore!)
            game?.scene.addChild(highScoreLabel!)
            game?.scene.addChild(retry)
            
            game?.audioInstance.backgroundMusicPlayer?.setVolume(0.05, fadeDuration: 1.0)
            overlay.run(SKAction.fadeAlpha(to: 0.6, duration: 0.5 ))
            block.run(SKAction.fadeIn(withDuration: 0.5))
            retry.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5 ))
            finalScore?.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5 ))
            highScoreLabel?.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5))
            
            
        }

    }
    
    override func willExit(to nextState: GKState) {

    }
    
}
