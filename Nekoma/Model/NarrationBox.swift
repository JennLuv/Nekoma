//
//  NarrationBox.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 26/06/24.
//

import SpriteKit

class NarrationBox: SKSpriteNode {
    weak var dungeonScene: DungeonScene?
    var soundManager = SoundManager()
    var textureName: String

    init(dungeonScene: DungeonScene, textureName: String) {
        self.dungeonScene = dungeonScene
        self.textureName = textureName
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zPosition = 20
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // print("touchesBegan")
        super.touchesBegan(touches, with: event)
        dungeonScene!.connectVirtualController()
        dungeonScene?.view?.isPaused = false
        soundManager.playSound(fileName: ButtonSFX.swapWeapon)
        soundManager.stopSound(fileName: BGM.gameplay)
        self.removeFromParent()
        if self.textureName == "winNarration" {
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                self.dungeonScene!.setGameOver(win: true)
                // print("Victory")
            }
        }
    }
    
    func addNarrationBox() {
        // print("addNarrationBox")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            self.dungeonScene!.disconnectVirtualController()
            self.position = CGPoint(x: 0, y: -120)
            self.dungeonScene!.cameraNode.addChild(self)
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                self.dungeonScene?.view?.isPaused = true
            }
        }
    }
}

