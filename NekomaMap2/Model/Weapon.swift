//
//  Weapon.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 18/06/24.
//

import SpriteKit

class Weapon: SKSpriteNode {
    var imageName: String
    var weaponName: String
    var rarity: RarityLevel
    var projectileName: String
    var attack: Int
    var category: String

    init(imageName: String, weaponName: String, rarity: RarityLevel, projectileName: String, attack: Int, category: String) {
        self.imageName = imageName
        self.weaponName = weaponName
        self.rarity = rarity
        self.projectileName = projectileName
        self.attack = attack
        self.category = category
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = "weapon"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func allWeapons() -> [Weapon] {
        let weapons: [Weapon] = [
            Weapon(imageName: "AK47Gun", weaponName: "AK47Gun", rarity: .common, projectileName: "AK47GunProj", attack: 2, category: "range"),
            Weapon(imageName: "Bow", weaponName: "Bow", rarity: .common, projectileName: "BowProj", attack: 3, category: "range"),
            Weapon(imageName: "DarknessKatana", weaponName: "DarknessKatana", rarity: .common, projectileName: "DarknessKatana", attack: 4, category: "melee"),
            Weapon(imageName: "DarknessScythe", weaponName: "DarknessScythe", rarity: .uncommon, projectileName: "DarknessScythe", attack: 5, category: "melee"),
            Weapon(imageName: "FireSword", weaponName: "FireSword", rarity: .uncommon, projectileName: "FireSword", attack: 6, category: "melee"),
            Weapon(imageName: "MagicWand", weaponName: "MagicWand", rarity: .rare, projectileName: "MagicWandProj", attack: 7, category: "range"),
            Weapon(imageName: "Shuriken", weaponName: "Shuriken", rarity: .rare, projectileName: "Shuriken", attack: 8, category: "range"),
            Weapon(imageName: "WoodAxe", weaponName: "WoodAxe", rarity: .rare, projectileName: "WoodAxe", attack: 9, category: "melee"),
        ]
        return weapons
    }
}
