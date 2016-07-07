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
    
    let menu = SKSpriteNode(imageNamed: "objectScreen")
    let xIcon = SKSpriteNode(imageNamed: "Xicon")
    let player1 = SKSpriteNode(imageNamed: "AirplaneCartoon")
    let player2 = SKSpriteNode(imageNamed: "AirplaneBlue")
    let player3 = SKSpriteNode(imageNamed: "PurpleBoy")
    let player4 = SKSpriteNode(imageNamed: "BlueBird")
    let player5 = SKSpriteNode(imageNamed: "Shark")
    let player6 = SKSpriteNode(imageNamed: "Dolphin")
    let player = SKSpriteNode(imageNamed: "BlueBird")
    let playerTwo = SKSpriteNode(imageNamed: "BlueBird")
    let playerThree = SKSpriteNode(imageNamed: "BlueBird")
    
    let objectMenu = SKSpriteNode(imageNamed: "objectScreen")
    let objectX = SKSpriteNode(imageNamed: "Xicon")
    let object1 = SKSpriteNode(imageNamed: "LightPinkBalloon")
    let object2 = SKSpriteNode(imageNamed: "PurpleBoat")
    let object3 = SKSpriteNode(imageNamed: "Star")
    let object4 = SKSpriteNode(imageNamed: "UFO")
    let object5 = SKSpriteNode(imageNamed: "BarnMedium")
    let object6 = SKSpriteNode(imageNamed: "Train")
    let object = SKSpriteNode(imageNamed: "PurpleBoat")
    let objectTwo = SKSpriteNode(imageNamed: "PurpleBoat")
    let objectThree = SKSpriteNode(imageNamed: "PurpleBoat")
    
    let tapRec = UITapGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let scaleRec = UIPinchGestureRecognizer()
    let dragRec = UIPanGestureRecognizer()
    
    //let increaseSize = SKAction.scaleXBy(1, y: CGFloat(1.5), duration: 0.5)
    
    var offset:CGFloat = 0
    var rotation:CGFloat = 0
    var doesMove:Int = 0
    var hasPressedOptions:Int = 0
    var numCharacters:Int = 0
    var hasPressedItems:Int = 0
    var numObjects:Int = 0
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        scene!.scaleMode = SKSceneScaleMode.ResizeFill
        
        self.view!.multipleTouchEnabled = true
        self.view!.userInteractionEnabled = true
        
        /*tapRec.addTarget(self, action: #selector(tapAction))
         tapRec.numberOfTapsRequired = 1
         tapRec.numberOfTouchesRequired = 1
         self.view!.addGestureRecognizer(tapRec)*/
        
        rotateRec.addTarget(self, action: #selector(rotateAction))
        self.view!.addGestureRecognizer(rotateRec)
        
        scaleRec.addTarget(self, action: #selector(scaleAction))
        
        //dragRec.addTarget(self, action: #selector(dragAction))
        
    }
    
    func rotateAction(sender:UIRotationGestureRecognizer) {
        if (sender.state == .Changed) {
            rotation = CGFloat(sender.rotation) + self.offset
            rotation = rotation * -1
            if (doesMove == 1) {
                player.zRotation = rotation
            } else if doesMove == 2 {
                playerTwo.zRotation = rotation
            } else if doesMove == 3 {
                playerThree.zRotation = rotation
            } else if doesMove == 4 {
                object.zRotation = rotation
            } else if doesMove == 5 {
                objectTwo.zRotation = rotation
            } else if doesMove == 6 {
                objectThree.zRotation = rotation
            }
        }
        if (sender.state == .Ended) {
            self.offset = rotation * -1
            doesMove = 0
        }
    }
    
    func scaleAction(sender:UIPinchGestureRecognizer) {
        print("pinched")
        if (sender.state == .Changed) {
            print("pinch changed")
            self.view!.transform = CGAffineTransformScale(self.view!.transform, sender.scale, sender.scale)
            sender.scale = 1
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
                } else if (node.name == "optionsButton" && hasPressedOptions == 0) {
                    menu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                    menu.name = "menu"
                    menu.zPosition = 8
                    self.addChild(menu)
                    player1.position = CGPointMake(215, 500)
                    player1.name = "player1"
                    player1.zPosition = 9
                    self.addChild(player1)
                    player2.position = CGPointMake(490, 500)
                    player2.name = "player2"
                    player2.zPosition = 9
                    self.addChild(player2)
                    player3.position = CGPointMake(765, 500)
                    player3.name = "player3"
                    player3.zPosition = 9
                    self.addChild(player3)
                    player4.position = CGPointMake(215, 325)
                    player4.name = "player4"
                    player4.zPosition = 9
                    self.addChild(player4)
                    player5.position = CGPointMake(490, 325)
                    player5.name = "player5"
                    player5.zPosition = 9
                    self.addChild(player5)
                    player6.position = CGPointMake(765, 325)
                    player6.name = "player6"
                    player6.zPosition = 9
                    self.addChild(player6)
                    xIcon.position = CGPointMake(825, 575)
                    xIcon.name = "xIcon"
                    xIcon.zPosition = 9
                    self.addChild(xIcon)
                    hasPressedOptions = 1
                } else if node.name == "player1" {
                    if numCharacters == 0 {player.texture = player1.texture; characters()}
                    else if numCharacters == 1 {playerTwo.texture = player1.texture; characters()}
                    else if numCharacters == 2 {playerThree.texture = player1.texture; characters()}
                    player1.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "player2" {
                    if numCharacters == 0 {player.texture = player2.texture; characters()}
                    else if numCharacters == 1 {playerTwo.texture = player2.texture; characters()}
                    else if numCharacters == 2 {playerThree.texture = player2.texture; characters()}
                    player2.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "player3" {
                    if numCharacters == 0 {player.texture = player3.texture; characters()}
                    else if numCharacters == 1 {playerTwo.texture = player3.texture; characters()}
                    else if numCharacters == 2 {playerThree.texture = player3.texture; characters()}
                    player3.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "player4" {
                    if numCharacters == 0 {player.texture = player4.texture; characters()}
                    else if numCharacters == 1 {playerTwo.texture = player4.texture; characters()}
                    else if numCharacters == 2 {playerThree.texture = player4.texture; characters()}
                    player4.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "player5" {
                    if numCharacters == 0 {player.texture = player5.texture; characters()}
                    else if numCharacters == 1 {playerTwo.texture = player5.texture; characters()}
                    else if numCharacters == 2 {playerThree.texture = player5.texture; characters()}
                    player5.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "player6" {
                    if numCharacters == 0 {player.texture = player6.texture; characters()}
                    else if numCharacters == 1 {playerTwo.texture = player6.texture; characters()}
                    else if numCharacters == 2 {playerThree.texture = player6.texture; characters()}
                    player6.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "player" {
                    doesMove = 1
                    player.position = location
                } else if node.name == "playerTwo" {
                    doesMove = 2
                    playerTwo.position = location
                } else if node.name == "playerThree" {
                    doesMove = 3
                    playerThree.position = location
                } else if node.name == "xIcon" {
                    self.removeChildrenInArray([player1, player2, player3, player4, player5, player6, menu, xIcon])
                } else if (node.name == "itemButton" && hasPressedItems == 0) {
                    objectMenu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                    objectMenu.name = "menu"
                    objectMenu.zPosition = 8
                    self.addChild(objectMenu)
                    object1.position = CGPointMake(215, 500)
                    object1.name = "object1"
                    object1.zPosition = 9
                    self.addChild(object1)
                    object2.position = CGPointMake(490, 500)
                    object2.name = "object2"
                    object2.zPosition = 9
                    self.addChild(object2)
                    object3.position = CGPointMake(765, 500)
                    object3.name = "object3"
                    object3.zPosition = 9
                    self.addChild(object3)
                    object4.position = CGPointMake(215, 325)
                    object4.name = "object4"
                    object4.zPosition = 9
                    self.addChild(object4)
                    object5.position = CGPointMake(490, 325)
                    object5.name = "object5"
                    object5.zPosition = 9
                    self.addChild(object5)
                    object6.position = CGPointMake(765, 325)
                    object6.name = "object6"
                    object6.zPosition = 9
                    self.addChild(object6)
                    objectX.position = CGPointMake(825, 575)
                    objectX.name = "objectX"
                    objectX.zPosition = 9
                    self.addChild(objectX)
                    hasPressedItems = 1
                } else if node.name == "object1" {
                    if numObjects == 0 {object.texture = object1.texture; objects()}
                    else if numObjects == 1 {objectTwo.texture = object1.texture; objects()}
                    else if numObjects == 2 {objectThree.texture = object1.texture; objects()}
                    object1.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "object2" {
                    if numObjects == 0 {object.texture = object2.texture; objects()}
                    else if numObjects == 1 {objectTwo.texture = object2.texture; objects()}
                    else if numObjects == 2 {objectThree.texture = object2.texture; objects()}
                    object2.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "object3" {
                    if numObjects == 0 {object.texture = object3.texture; objects()}
                    else if numObjects == 1 {objectTwo.texture = object3.texture; objects()}
                    else if numObjects == 2 {objectThree.texture = object3.texture; objects()}
                    object3.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "object4" {
                    if numObjects == 0 {object.texture = object4.texture; objects()}
                    else if numObjects == 1 {objectTwo.texture = object4.texture; objects()}
                    else if numObjects == 2 {objectThree.texture = object4.texture; objects()}
                    object4.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "object5" {
                    if numObjects == 0 {object.texture = object5.texture; objects()}
                    else if numObjects == 1 {objectTwo.texture = object5.texture; objects()}
                    else if numObjects == 2 {objectThree.texture = object5.texture; objects()}
                    object5.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "object6" {
                    if numObjects == 0 {object.texture = object6.texture; objects()}
                    else if numObjects == 1 {objectTwo.texture = object6.texture; objects()}
                    else if numObjects == 2 {objectThree.texture = object6.texture; objects()}
                    object6.texture = SKTexture(imageNamed: "CheckmarkIcon")
                } else if node.name == "object" {
                    doesMove = 4
                    object.position = location
                } else if node.name == "objectTwo" {
                    doesMove = 5
                    objectTwo.position = location
                } else if node.name == "objectThree" {
                    doesMove = 6
                    objectThree.position = location
                }  else if node.name == "objectX" {
                    self.removeChildrenInArray([object1, object2, object3, object4, object5, object6, objectMenu, objectX])
                }
            }
        }
    }
    
    func characters() {
        if numCharacters == 0 {
            player.position = CGPointMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame) - 100)
            player.name = "player"
            player.zPosition = 2
            self.addChild(player)
            numCharacters = 1
        } else if numCharacters == 1 {
            playerTwo.position = CGPointMake(CGRectGetMidX(self.frame) - 50, CGRectGetMidY(self.frame) + 50)
            playerTwo.name = "playerTwo"
            playerTwo.zPosition = 3
            self.addChild(playerTwo)
            numCharacters = 2
        } else if numCharacters == 2 {
            playerThree.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            playerThree.name = "playerThree"
            playerThree.zPosition = 4
            self.addChild(playerThree)
            numCharacters = 3
        }
    }
    
    func objects() {
        if numObjects == 0 {
            object.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            object.name = "object"
            object.zPosition = 5
            self.addChild(object)
            numObjects = 1
        } else if numObjects == 1 {
            objectTwo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            objectTwo.name = "objectTwo"
            objectTwo.zPosition = 6
            self.addChild(objectTwo)
            numObjects = 2
        } else if numObjects == 2 {
            objectThree.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            objectTwo.name = "objectThree"
            objectThree.zPosition = 7
            self.addChild(objectThree)
            numObjects = 3
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let nodes = self.nodesAtPoint(location) as [SKNode]
            
            for node in nodes {
                if (node.name == "player" && doesMove == 1) {
                    doesMove = 1
                    player.position = location
                    player.zPosition = 2
                } else if (node.name == "playerTwo" && doesMove == 2) {
                    doesMove = 2
                    playerTwo.position = location
                    playerTwo.zPosition = 3
                } else if (node.name == "playerThree" && doesMove == 3) {
                    doesMove = 3
                    playerThree.position = location
                    playerThree.zPosition = 4
                } else if (node.name == "object" && doesMove == 4) {
                    doesMove = 4
                    object.position = location
                    object.zPosition = 5
                } else if (node.name == "objectTwo" && doesMove == 5) {
                    doesMove = 5
                    objectTwo.position = location
                    objectTwo.zPosition = 6
                } else if (node.name == "objectThree" && doesMove == 6) {
                    doesMove = 6
                    objectThree.position = location
                    objectThree.zPosition = 7
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        doesMove = 0
    }
    
    func removeGestures() {
        rotateRec.removeTarget(self, action: #selector(rotateAction))
        self.view!.gestureRecognizers?.removeAll()
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
