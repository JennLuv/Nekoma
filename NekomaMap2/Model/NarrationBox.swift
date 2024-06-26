//
//  NarrationBox.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 26/06/24.
//

import SpriteKit

class NarrationBox: SKSpriteNode {
    weak var dungeonScene: DungeonScene2?
    var soundManager = SoundManager()

    init(dungeonScene: DungeonScene2) {
        self.dungeonScene = dungeonScene
        let texture = SKTexture(imageNamed: "winNarration")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zPosition = 20
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        soundManager.playSound(fileName: ButtonSFX.swapWeapon)
        self.removeFromParent()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [self] in
            dungeonScene!.setGameOver(win: true)
            print("Victory")
        }
    }
    
    func addNarrationBox(to scene: DungeonScene2) {
        self.position = CGPoint(x: 0, y: -120)
        scene.cameraNode.addChild(self)
    }
}

