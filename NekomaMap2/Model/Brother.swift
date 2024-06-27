//
//  Brother.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 26/06/24.
//

import SpriteKit

class Brother: SKSpriteNode {
    static let brotherTextureAtlas = SKTextureAtlas(named: "brother")
    
    // MARK: Initialization
    init() {
        let texture = SKTexture(imageNamed: "brother1")
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func spawnBrotherNode(at position: CGPoint) -> Brother {
        let brother = Brother()
        brother.position = CGPoint(x: position.x - 4, y: position.y)
        brother.size = CGSize(width: 40, height: 40)
        brother.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 10))
        brother.physicsBody?.isDynamic = false
        brother.physicsBody?.usesPreciseCollisionDetection = true
        brother.physicsBody?.categoryBitMask = PhysicsCategory.target
        brother.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        return brother
    }
    
    static func jumpAnimation() -> SKAction {
        var jumpFrames: [SKTexture] = []
        for i in 1...4 {
            let textureName = "brother\(i)"
            jumpFrames.append(brotherTextureAtlas.textureNamed(textureName))
        }
        
        let jump = SKAction.animate(with: jumpFrames, timePerFrame: 0.2)
        let moveRight = SKAction.moveBy(x: 30, y: -30, duration: 0.8)
        
        return SKAction.group([jump, moveRight])
    }
    
    static func jumpUpDownAnimation() -> SKAction {
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.3)
        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 0.3)
        let upDownSequence = SKAction.sequence([moveUp, moveDown, moveUp, moveDown])
        return upDownSequence
    }
    
    static func jump(brotherNode: Brother) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            brotherNode.zPosition = 1
            let jumpSequence = SKAction.sequence([
                jumpAnimation(),
                jumpUpDownAnimation()
            ])
            brotherNode.run(jumpSequence)
        }
    }
}
