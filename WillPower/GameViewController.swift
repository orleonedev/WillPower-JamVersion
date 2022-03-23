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
    
    let swipeRightRecog = UISwipeGestureRecognizer()
    let swipeLeftRecog = UISwipeGestureRecognizer()
    let swipeUpRecog = UISwipeGestureRecognizer()
    let swipeDownRecog = UISwipeGestureRecognizer()

    override func viewDidLoad() {
        swipeRightRecog.addTarget(self, action: #selector(self.swipedRight))
        swipeRightRecog.direction = .right
        self.view?.addGestureRecognizer(swipeRightRecog)
        
        swipeLeftRecog.addTarget(self, action: #selector(self.swipedLeft))
        swipeLeftRecog.direction = .left
        self.view?.addGestureRecognizer(swipeLeftRecog)
        
        swipeUpRecog.addTarget(self, action: #selector(self.swipedUp))
        swipeUpRecog.direction = .up
        self.view?.addGestureRecognizer(swipeUpRecog)
        
        swipeDownRecog.addTarget(self, action: #selector(self.swipedDown))
        swipeDownRecog.direction = .down
        self.view?.addGestureRecognizer(swipeDownRecog)
        
        super.viewDidLoad()
        
        game = WPGame()
        if let scene = game?.scene {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            // Present the scene
            if let view = self.view as! SKView? {
                scene.size = self.view.frame.size
                view.presentScene(scene)
                view.ignoresSiblingOrder = true
                view.showsPhysics = false
                view.showsFPS = true
                view.showsNodeCount = true
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
    
    @objc func swipedRight(){
        
        print("Swiped Right")
        
        if let shield = game?.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldRight()
          //  shield.sprite?.physicsBody = shield.sprite?.shieldBodyRight()
        }
    }
    
    @objc func swipedLeft(){
        
        print("Swiped Left")
        
        if let shield = game?.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldLeft()
           // shield.sprite?.physicsBody = shield.sprite?.shieldBodyLeft()
        }
    }
    
    @objc func swipedUp(){
       
        print("Swiped Up")
        
        if let shield = game?.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldUp()
          //  shield.sprite?.physicsBody = shield.sprite?.shieldBodyUp()
        }
        
    }
    
    @objc func swipedDown(){
        
        print("Swiped Down")
        
        if let shield = game?.shield.component(ofType: WPSpriteComponent.self){
            shield.sprite?.shieldDown()
            //shield.sprite?.physicsBody = shield.sprite?.shieldBodyDown()
        }
        
    }
    
}
