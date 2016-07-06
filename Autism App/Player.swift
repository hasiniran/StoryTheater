//
//  Player.swift
//  Autism App
//
//  Created by Ben Kennel on 7/1/16.
//  Copyright © 2016 Mobile Computing Lab. All rights reserved.
//

import UIKit
import SpriteKit

class Player: NSObject, NSCoding {
    //Instance variables
    var sprite: SKSpriteNode?
    var score: Int
    
    init(sprite: SKSpriteNode) {
        self.sprite=sprite
        self.score=0
    }
    
    required init(coder: NSCoder) {
        self.sprite=coder.decodeObjectForKey("sprite") as? SKSpriteNode
        self.score=coder.decodeObjectForKey("score") as! Int
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.sprite, forKey: "sprite")
        aCoder.encodeObject(self.score, forKey: "score")
        
    }
    
    func save() {
        //let defaults=NSUserDefaults.standardUserDefaults()
        
    }
    
    func load() {
        
    }
    
}
