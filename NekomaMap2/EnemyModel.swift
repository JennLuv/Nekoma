//
//  EnemyModel.swift
//  NekomaMap2
//
//  Created by Nur Nisrina on 12/06/24.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    var health: Int
    var attackSpeed: Int
    var range: CGPoint
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, health: Int, speed: CGFloat, attackSpeed: Int, range: CGPoint) {
        self.health = health
        self.attackSpeed = attackSpeed
        self.range = range
        super.init(texture: texture, color: color, size: size)
        self.setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = 0x1 << 1
        self.physicsBody?.contactTestBitMask = 0x1 << 0
        self.physicsBody?.collisionBitMask = 0x1 << 0
        self.physicsBody?.allowsRotation = false
    }
    
    func chasePlayer(player: SKSpriteNode) {
        let playerPosition = player.position
        let dx = playerPosition.x - position.x
        let dy = playerPosition.y - position.y
        let angle = atan2(dy, dx)
        
        let speed: CGFloat = 20.0
        let vx = cos(angle) * speed
        let vy = sin(angle) * speed
        self.physicsBody?.velocity = CGVector(dx: vx, dy: vy)
    }
}

class MeleeEnemy: Enemy {
    init() {
        let texture = SKTexture(imageNamed: "Melee")
        super.init(texture: texture, color: .clear, size: texture.size(), health: 100, speed: 1.0, attackSpeed: 10, range: CGPoint(x: 10, y: 10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RangedEnemy: Enemy {
    init() {
        let texture = SKTexture(imageNamed: "Ranged")
        super.init(texture: texture, color: .clear, size: texture.size(), health: 50, speed: 0.4, attackSpeed: 20, range: CGPoint(x:20, y:20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
