//
//  HomeScene.swift
//  Autism App
//
//  Created by Ben Kennel on 7/1/16.
//  Copyright © 2016 Mobile Computing Lab. All rights reserved.
//

import UIKit
import SpriteKit

class HomeScene: SKScene {
    var transition: SKTransition?
    var player: Player?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        scene!.scaleMode = SKSceneScaleMode.ResizeFill
        //self.player=playerToLoad
        //let player=SKSpriteNode(coder: <#T##NSCoder#>)
        //let playerNode=SKSpriteNode(imageNamed: player.sprite!)
        //player!.sprite!.position=CGPointMake((scene?.view?.bounds.width)!/2, (scene?.view?.bounds.height)!/2)
        //self.addChild(player!.sprite!)
        
    }
    
    func loadPlayer(playerToLoad: Player) {
        print("loading chosen character")
        player=playerToLoad
        //let playerNode=SKSpriteNode(imageNamed: player.sprite!)
        //let playerNode=player?.sprite!
        player!.sprite!.position=CGPointMake(500, 500)
        self.addChild(player!.sprite!)
        //player!.sprite!.position=CGPointMake((scene?.view?.bounds.width)!/2, (scene?.view?.bounds.height)!/2)

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
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
