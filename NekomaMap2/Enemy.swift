//
//  Enemy.swift
//  NekomaMap2
//
//  Created by mg0 on 13/06/24.
//

import SpriteKit


import Foundation

class EnemyDummy {
    var hp: Int
    var imageName: String
    var name: String
    
    init(hp: Int, imageName: String, name: String) {
        self.hp = hp
        self.imageName = imageName
        self.name = name
    }
}

class Enemy1: EnemyDummy {
    var maxHP: Int
    
    init(hp: Int, imageName: String, maxHP: Int, name: String) {
        self.maxHP = maxHP
        super.init(hp: hp, imageName: imageName, name: name)
    }

    func spawnInScene(scene: SKScene, atPosition position: CGPoint) {
        let enemyExample = SKSpriteNode(imageNamed: self.imageName)
        enemyExample.physicsBody = SKPhysicsBody(texture: enemyExample.texture!, size: enemyExample.size)
        enemyExample.physicsBody?.isDynamic = false
        enemyExample.physicsBody?.usesPreciseCollisionDetection = true
        enemyExample.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemyExample.physicsBody?.collisionBitMask = PhysicsCategory.enemy
        enemyExample.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        enemyExample.position = position
        enemyExample.physicsBody?.node?.userData = NSMutableDictionary()
        // super simplified hack
        enemyExample.physicsBody?.node?.userData?.setValue(hp, forKey: "hp")
        scene.addChild(enemyExample)
    }
}
