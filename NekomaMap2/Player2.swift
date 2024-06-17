//
//  Player2.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 17/06/24.
//

import SpriteKit

class Player2: SKSpriteNode {
    var hp: Int {
        didSet {
            updateHPBar()
        }
    }
    var maxHP: Int
    private let hpBarBackground: SKSpriteNode
    private let hpBarForeground: SKSpriteNode

    init(hp: Int, imageName: String, maxHP: Int, name: String) {
        self.hp = hp
        self.maxHP = maxHP
        let texture = SKTexture(imageNamed: imageName)
        
        self.hpBarBackground = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 5))
        self.hpBarForeground = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 5))
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = name
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.isDynamic = true
        
        self.position = CGPoint(x: 0, y: 0)
        self.setScale(0.55)
        
        // Set up physics body for the player
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        
        // Configure the HP bar
        hpBarBackground.position = CGPoint(x: 0, y: size.height / 2 + 15)
        hpBarForeground.position = CGPoint(x: 0, y: size.height / 2 + 15)
        
        addChild(hpBarBackground)
        addChild(hpBarForeground)
        
        updateHPBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func spawnInScene(scene: SKScene, atPosition position: CGPoint) {
        self.position = position
        scene.addChild(self)
    }

    func takeDamage(_ damage: Int) {
        hp -= damage
        updateHPBar()
        
        if hp <= 0 {
            self.removeFromParent()
        }
    }

    private func updateHPBar() {
        let hpRatio = CGFloat(hp) / CGFloat(maxHP)
        hpBarForeground.size.width = hpBarBackground.size.width * hpRatio
        hpBarForeground.position = CGPoint(x: -hpBarBackground.size.width / 2 + hpBarForeground.size.width / 2, y: hpBarBackground.position.y)
    }
}
