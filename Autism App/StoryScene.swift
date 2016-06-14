//
//  StoryScene.swift
//  Autism App
//
//  Created by Henry Long on 6/1/16.
//  Copyright © 2016 Mobile Computing Lab. All rights reserved.
//

import UIKit
import SpriteKit

class StoryScene: SKScene, UIGestureRecognizerDelegate {
    
    var transition: SKTransition?
    
    let menu = SKSpriteNode(imageNamed: "AirplaneBlue")
    
    let tapRec = UITapGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let scaleRec = UIPinchGestureRecognizer()
    let dragRec = UIPanGestureRecognizer()
    
    var offset:CGFloat = 0
    var rotation:CGFloat = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        scene!.scaleMode = SKSceneScaleMode.ResizeFill
        
        self.view!.multipleTouchEnabled = true
        self.view!.userInteractionEnabled = true
        
        tapRec.addTarget(self, action: #selector(tapAction))
        tapRec.numberOfTapsRequired = 1
        tapRec.numberOfTouchesRequired = 1
        self.view!.addGestureRecognizer(tapRec)
        
        rotateRec.addTarget(self, action: #selector(rotateAction))
        self.view!.addGestureRecognizer(rotateRec)
        
        dragRec.addTarget(self, action: #selector(dragAction))
        
    }
    
    func tapAction(sender:UITapGestureRecognizer) {
        print("was tapped")
    }
    
    func rotateAction(sender:UIRotationGestureRecognizer) {
        if (sender.state == .Changed) {
            rotation = CGFloat(sender.rotation) + self.offset
            rotation = rotation * -1
            menu.zRotation = rotation
        }
        if (sender.state == .Ended) {
            self.offset = rotation * -1
        }
    }
    
    func dragAction(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        
        recognizer.view!.center = CGPoint(x: recognizer.view!.center.x + translation.x, y: recognizer.view!.center.y + translation.y)
        
        recognizer.setTranslation(CGPointZero, inView: self.view)
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
                } else if node.name == "optionsButton" {
                    menu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                    menu.name = "menu"
                    menu.zPosition = 1
                    self.addChild(menu)
                } else if node.name == "menu" {
                    menu.position = location
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let nodes = self.nodesAtPoint(location) as [SKNode]
            
            for node in nodes {
                if node.name == "menu" {
                    menu.position = location
                    menu.zPosition = 1
                }
            }
        }

    }
    
    func removeGestures() {
        rotateRec.removeTarget(self, action: #selector(rotateAction))
        self.view!.gestureRecognizers?.removeAll()
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
