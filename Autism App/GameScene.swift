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
    var playerType: String?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        freePlay = childNodeWithName("freePlay") as? SKSpriteNode
        storyPlay = childNodeWithName("storyPlay") as? SKSpriteNode
        savedStories = childNodeWithName("savedStories") as? SKSpriteNode
        //scene!.scaleMode = SKSceneScaleMode.ResizeFill
        
        //Check for saved data
        let defaults=NSUserDefaults.standardUserDefaults()
        //Uncomment next 2 lines to delete saved data
        //let appDomain = NSBundle.mainBundle().bundleIdentifier!
        //defaults.removePersistentDomainForName(appDomain)
        if let type=defaults.objectForKey("type") as? String {
            //Player data exists
            playerType=type
            print("player data found")
        }
    }
    
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let nodes = self.nodesAtPoint(location) as [SKNode]
            
            for node in nodes {
                if node.name == "freePlay" {
                    transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                    
                    let nextScene = FreeScene(fileNamed: "FreeScene")
                    nextScene!.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene!, transition: transition!)
                } else if node.name == "storyPlay" {
                    transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                    
                    let nextScene = StoryScene(fileNamed: "StoryScene")
                    nextScene!.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene!, transition: transition!)
                } else if node.name == "savedStories" {
                    transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                    
                    if playerType == nil{
                        let nextScene = StartupScene(fileNamed: "StartupScene")
                        nextScene!.scaleMode = .AspectFill
                    
                        scene?.view?.presentScene(nextScene!, transition: transition!)
                    } else {
                        var sprite: SKSpriteNode?
                        if playerType=="airplane"{
                            sprite=SKSpriteNode(imageNamed: "AirplaneCartoon")
                        }else if playerType=="train"{
                            sprite=SKSpriteNode(imageNamed: "Train")
                        }else{
                            sprite=SKSpriteNode(imageNamed: "UFO")
                        }
                        let character=Player(sprite: sprite!)
                        
                        let nextScene = HomeScene(fileNamed: "HomeScene")
                        nextScene!.scaleMode = .AspectFill
                        print("loading home screen")
                        nextScene!.loadPlayer(character)
                        scene?.view?.presentScene(nextScene!, transition: transition!)
                    }
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
