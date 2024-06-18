//
//  WeaponSlotButton.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 18/06/24.
//

import Foundation
import SpriteKit

class WeaponSlotButton: SKSpriteNode {
    private let backgroundTexture = SKTexture(imageNamed: "WeaponSlotButton")
    private var currentWeaponTexture: SKTexture?
    private var currentWeapon: Weapon
    
    init(currentWeapon: Weapon) {
        self.currentWeapon = currentWeapon
        self.currentWeaponTexture = SKTexture(imageNamed: currentWeapon.weaponName)
        
        super.init(texture: backgroundTexture, color: .clear, size: CGSize(width: 50, height: 50))
        
        self.name = "weaponSlotButton"
        self.isUserInteractionEnabled = true
        
        updateButtonAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTexture(with weapon: Weapon?) {
        if let weapon = weapon {
            currentWeaponTexture = SKTexture(imageNamed: weapon.weaponName)
        } else {
            currentWeaponTexture = nil
        }
        
        updateButtonAppearance()
    }
    
    private func updateButtonAppearance() {
        self.removeAllChildren()
        self.texture = backgroundTexture
        
        if let weaponTexture = currentWeaponTexture {
            let weaponNode = SKSpriteNode(texture: weaponTexture, color: .clear, size: self.size)
            weaponNode.zPosition = 1
            weaponNode.name = "weaponTexture"
            weaponNode.position = CGPoint(x: 0, y: 0)
            self.addChild(weaponNode)
        }
    }

}
