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
        print("scene loaded")
        
        if character != nil {
            //skip to next scene
            let nextScene=SavedScene(fileNamed: "SavedScene")
            nextScene!.scaleMode = .AspectFill
            print("loading home")
            scene?.view?.presentScene(nextScene!)
        } else {
            print("loading startup")
            scene!.scaleMode = SKSceneScaleMode.ResizeFill
        }
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
                    transition = SKTransition.revealWithDirection(.Up, duration: 1.0)
                    let nextScene = HomeScene(fileNamed: "HomeScene")
                    nextScene!.loadPlayer(character!)
                    nextScene!.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene!, transition: transition!)
                } else if node.name == "icon2" {
                    let sprite=SKSpriteNode(imageNamed: "Train")
                    character=Player(sprite: sprite)
                    print("train selected")
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
