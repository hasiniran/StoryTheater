//
//  GameScene.swift
//  Autism App
//
//  Created by Henry Long on 5/24/16.
//  Copyright (c) 2016 Mobile Computing Lab. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var freePlay: SKSpriteNode?
    var storyPlay: SKSpriteNode?
    var savedStories: SKSpriteNode?
    var transition: SKTransition?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        freePlay = childNodeWithName("freePlay") as? SKSpriteNode
        storyPlay = childNodeWithName("storyPlay") as? SKSpriteNode
        savedStories = childNodeWithName("savedStories") as? SKSpriteNode

    }
    
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let nodes = self.nodesAtPoint(location) as [SKNode]
            
            for node in nodes {
                if node.name == "freePlay" {
                    transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                    
                    let nextScene = StoryScene(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene, transition: transition!)
                } else if node.name == "storyPlay" {
                    transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                    
                    let nextScene = StoryScene(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene, transition: transition!)
                } else if node.name == "savedStories" {
                    transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                    
                    let nextScene = StoryScene(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene, transition: transition!)
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
