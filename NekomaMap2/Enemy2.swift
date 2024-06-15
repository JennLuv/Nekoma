import SpriteKit

class Enemy2: SKSpriteNode {
    var hp: Int {
        didSet {
            hpLabel.text = "HP: \(hp)"
        }
    }
    var maxHP: Int
    private let hpLabel: SKLabelNode

    init(hp: Int, imageName: String, maxHP: Int, name: String) {
        self.hp = hp
        self.maxHP = maxHP
        let texture = SKTexture(imageNamed: imageName)
        self.hpLabel = SKLabelNode(text: "HP: \(hp)")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = name
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        // Configure the HP label
        hpLabel.fontSize = 14
        hpLabel.fontColor = .white
        hpLabel.position = CGPoint(x: 0, y: -size.height / 2 - 10)
        
        // Add the HP label as a child node
        self.addChild(hpLabel)
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
        hpLabel.text = "HP: \(hp)"
        
        // Remove the enemy if its HP is 0 or less
        if hp <= 0 {
            self.removeFromParent()
        }
    }
}
