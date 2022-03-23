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
    
}
