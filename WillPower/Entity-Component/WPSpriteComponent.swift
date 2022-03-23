//
//  WPSpriteComponent.swift
//  WillPower
//
//  Created by Oreste Leone on 22/03/22.
//

import SpriteKit
import GameplayKit

class WPSpriteComponent: GKComponent {
    var sprite: WPSpriteNode?
    var defaultColor: SKColor
    
    var pulseEffectEnabled: Bool = false {
        didSet {
            if (pulseEffectEnabled) {
                let grow = SKAction.scale(by: 1.1, duration: 0.2)
                let sequence = SKAction.sequence([grow, grow.reversed()])
                
                sprite?.run(SKAction.repeatForever(sequence), withKey: "pulse")
            } else {
                sprite?.removeAction(forKey: "pulse")
                sprite?.run(SKAction.scale(to: 1.0, duration: 0.5))
            }
        }
    }
    
    init(withDefaultColor defaultColor: SKColor) {
        self.defaultColor = defaultColor
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func useNormalAppearance() {
        sprite?.color = defaultColor
    }
    
    func useDefeatedAppearance() {
        sprite?.run(SKAction.scale(to: 0.25, duration: 0.25))
    }
}
