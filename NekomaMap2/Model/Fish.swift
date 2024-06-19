//
//  Fish.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 19/06/24.
//

import Foundation
import SpriteKit

class Fish: SKSpriteNode {
    var fishName: String

    init(imageName: String, fishName: String) {
        self.fishName = fishName
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = "fish"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

