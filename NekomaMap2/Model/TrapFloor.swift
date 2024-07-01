//
//  TrapFloor.swift
//  NekomaMap2
//
//  Created by Nur Nisrina on 26/06/24.
//

import SpriteKit

class TrapFloor: SKSpriteNode {
    private var isActivatingTrap = false
    
    init(position: CGPoint) {
        let texture = SKTexture(imageNamed: "trap")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.setScale(0.27)
        self.setupPhysicsBody(texture: texture)
        self.position = position
        self.trapAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody(texture: SKTexture) {
        print("setupPhysicsBody")
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody = nil
    }
    
    func activateTrap(player: Player2) {
        print("activateTrap")
        let minX = self.position.x - 18
        let maxX = self.position.x + 18
        let minY = self.position.y - 18
        let maxY = self.position.y + 18
        
        if player.position.x >= minX && player.position.x <= maxX && player.position.y >= minY && player.position.y <= maxY {
            player.takeDamage(1)
        }

    }
    
    func animate(frames: [SKTexture]) {
        print("animate")
        let animation = SKAction.animate(with: frames, timePerFrame: 0.2)
        let repeatAction = SKAction.repeatForever(animation)
        self.run(repeatAction)
    }
    
    func trapAnimation() {
        print("trapAnimation")
        let trapFrames: [SKTexture] = [
            SKTexture(imageNamed: "trap0"),
            SKTexture(imageNamed: "trap1")
        ]
        self.animate(frames: trapFrames)
    }
}
