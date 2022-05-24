//
//  GameViewController.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
    var game: WPGame?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        game = WPGame()
        game?.viewDelegate = self
        if let scene = game?.scene {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            // Present the scene
            if let view = self.view as! SKView? {
                scene.size = self.view.frame.size
                view.presentScene(scene)
                view.ignoresSiblingOrder = true
                view.showsPhysics = false
                view.showsFPS = false
                view.showsNodeCount = false
            }
        }
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
