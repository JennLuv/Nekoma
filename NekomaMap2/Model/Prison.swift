//
//  Prison.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 26/06/24.
//

import SpriteKit

class Prison: SKSpriteNode {
    var isOpened: Bool = false
    static let prisonTextureAtlas = SKTextureAtlas(named: "prison")
    
    // MARK: Initialization
    init() {
        let texture = SKTexture(imageNamed: "prison1")
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func spawnPrisonNode(at position: CGPoint) -> Prison {
        let prison = Prison()
        prison.position = CGPoint(x: position.x + 2, y: position.y + 15)
        prison.size = CGSize(width: 120, height: 120)
        prison.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 50, height: 75))
        prison.physicsBody?.isDynamic = false
        prison.physicsBody?.usesPreciseCollisionDetection = true
        prison.physicsBody?.categoryBitMask = PhysicsCategory.target
        prison.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        return prison
    }
    
    static func prisonAnimation() -> SKAction {
        var chestFrames: [SKTexture] = []
        for i in 1...4 {
            let textureName = "prison\(i)"
            chestFrames.append(prisonTextureAtlas.textureNamed(textureName))
        }
        return SKAction.animate(with: chestFrames, timePerFrame: 0.7)
    }
    
    static func changeTextureToOpened(prisonNode: Prison) {
        prisonNode.isOpened = true
        prisonNode.run(Prison.prisonAnimation())
    }
}
