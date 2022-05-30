//
//  Scene.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import Foundation
import SpriteKit
import GameplayKit

protocol SceneDelegate: SKSceneDelegate {
    func didMoveToView(scene: WPScene , view: SKView)
    
}

class WPScene: SKScene {
    
    var sceneDelegate: SceneDelegate?
    
    override func didMove(to view: SKView) {
        sceneDelegate?.didMoveToView(scene: self, view: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let game = sceneDelegate as? WPGame {
            game.update(currentTime: currentTime, forScene: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstT = touches.first{
            let location = firstT.location(in: self)
        let nodeAtPoint = atPoint(location)
        if let touchedNode = nodeAtPoint as? SKSpriteNode{
            if touchedNode.name == "retry" {
                let newGame = WPGame()
                if let game = sceneDelegate as? WPGame {
                    newGame.viewDelegate = game.viewDelegate
                }
                newGame.isFirstTime = false
                let scene = newGame.scene
                scene.size = (self.view?.frame.size)!
                scene.scaleMode = .aspectFit
                view?.presentScene(scene, transition: .fade(withDuration: 1.5))
                }
            
            if touchedNode.name == "firstTime" || touchedNode.name == "overlayFirst" {
                if let game = sceneDelegate as? WPGame {
                    game.start()
                }
            }
            
            if touchedNode.name == "cup" {
                if let game = sceneDelegate as? WPGame {
                    if let view = game.viewDelegate as? GameViewController {
                        view.showLeaderboard()
                    }
                }
            }
            }
            if let touchedNode = nodeAtPoint as? SKLabelNode {
                if touchedNode.name == "press" || touchedNode.name == "title" || touchedNode.name == "highScoreFirst"{
                    if let game = sceneDelegate as? WPGame {
                        game.start()
                    }
                }
            }
        }
    }
}
