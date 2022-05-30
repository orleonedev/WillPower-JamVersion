//
//  GameViewController.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool()
    var gcDefaultLeaderboard = String()
    let LEADERBOARD_ID = "highest_score"
    
    var game: WPGame?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        authenticateLocalPlayer()
        
        game = WPGame()
        game?.viewDelegate = self
//        if GKLocalPlayer.local.isAuthenticated {
//            if let userdefault = game?.highestScore {
//                GKLeaderboard.submitScore(userdefault, context: 0, player: GKLocalPlayer.local,
//                                          leaderboardIDs: ["highest_score"]) { error in
//                }
//            }
//            
//        }
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
    
    func showLeaderboard() {
        print("SHOW LEADERBOARD")
        let viewController = GKGameCenterViewController(leaderboardID: LEADERBOARD_ID, playerScope: .global, timeScope: .allTime)
        viewController.gameCenterDelegate = self
        
        present(viewController, animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer(){
        let localPlayer :GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                ViewController?.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderboard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
