//
//  Weapon.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 18/06/24.
//

import SpriteKit

class Weapon: SKSpriteNode {
    var weaponName: String

    init(imageName: String, weaponName: String) {
        self.weaponName = weaponName
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = "weapon"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
