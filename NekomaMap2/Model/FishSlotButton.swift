//
//  FishSlotButton.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 19/06/24.
//

import Foundation
import SpriteKit

class FishSlotButton: SKSpriteNode {
    private let backgroundTexture = SKTexture(imageNamed: "FishSlotButton")
    private var currentFishTexture: SKTexture?
    private var currentFish: Fish
    
    init(currentFish: Fish) {
        self.currentFish = currentFish
        self.currentFishTexture = SKTexture(imageNamed: currentFish.fishName)
        
        super.init(texture: backgroundTexture, color: .clear, size: backgroundTexture.size())
        
        self.name = "fishSlotButton"
        self.isUserInteractionEnabled = false
        
        updateButtonAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTexture(with fish: Fish?) {
        if let fish = fish {
            currentFishTexture = SKTexture(imageNamed: fish.fishName)
        } else {
            currentFishTexture = nil
        }
        
        updateButtonAppearance()
    }
    
    private func updateButtonAppearance() {
            self.removeAllChildren()
            self.texture = backgroundTexture
            
            if let fishTexture = currentFishTexture {
                let fishNode = SKSpriteNode(texture: fishTexture, color: .clear, size: fishTexture.size())
                fishNode.zPosition = 1
                fishNode.name = "fishTexture"
                fishNode.position = CGPoint(x: 0, y: 0)
                
                let fishSize = fishTexture.size()
                let aspectRatio = fishSize.width / fishSize.height
                let backgroundSize = self.size
                
                var newFishSize: CGSize
                if backgroundSize.width / aspectRatio <= backgroundSize.height {
                    newFishSize = CGSize(width: backgroundSize.width, height: backgroundSize.width / aspectRatio)
                } else {
                    newFishSize = CGSize(width: backgroundSize.height * aspectRatio, height: backgroundSize.height)
                }
                
                fishNode.size = newFishSize
                self.addChild(fishNode)
            }
        }

}
