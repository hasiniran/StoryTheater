//
//  StartupScene.swift
//  Autism App
//
//  Created by Ben Kennel on 6/30/16.
//  Copyright © 2016 Mobile Computing Lab. All rights reserved.
//

import UIKit
import SpriteKit

class StartupScene: SKScene {
    var transition: SKTransition?
    var character: Player?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        scene!.scaleMode = SKSceneScaleMode.ResizeFill
        print("scene loaded")

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let nodes = self.nodesAtPoint(location) as [SKNode]
            
            for node in nodes {
                if node.name == "backArrow" {
                    transition = SKTransition.revealWithDirection(.Up, duration: 1.0)
                    
                    let nextScene = GameScene(fileNamed: "GameScene")
                    nextScene!.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene!, transition: transition!)
                } else if node.name == "icon1" {
                    let sprite=SKSpriteNode(imageNamed: "AirplaneCartoon") //substitute for any character
                    character=Player(sprite: sprite)
                    print("airplane selected")
                    //Save character choice
                    let defaults=NSUserDefaults.standardUserDefaults()
                    //defaults.setObject(character, forKey: "player")
                    defaults.setObject("airplane", forKey: "type")
                    
                    transition = SKTransition.revealWithDirection(.Up, duration: 1.0)
                    let nextScene = HomeScene(fileNamed: "HomeScene")
                    nextScene!.loadPlayer(character!)
                    nextScene!.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene!, transition: transition!)
                } else if node.name == "icon2" {
                    let sprite=SKSpriteNode(imageNamed: "Train")
                    character=Player(sprite: sprite)
                    print("train selected")
                    let defaults=NSUserDefaults.standardUserDefaults()
                    //defaults.setObject(character, forKey: "player")
                    defaults.setObject("train", forKey: "type")
                    
                    transition = SKTransition.revealWithDirection(.Up, duration: 1.0)
                    let nextScene = HomeScene(fileNamed: "HomeScene")
                    nextScene!.loadPlayer(character!)
                    nextScene!.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene!, transition: transition!)
                    
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
