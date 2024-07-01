import Foundation
import SpriteKit

class WeaponSlotButton: SKSpriteNode {
    private let backgroundTexture = SKTexture(imageNamed: "WeaponSlotButton")
    var currentWeaponTexture: SKTexture?
    var _currentWeapon: Weapon
    
    var currentWeapon: Weapon {
        get {
            return _currentWeapon
        }
        set {
            _currentWeapon = newValue
            currentWeaponTexture = SKTexture(imageNamed: newValue.weaponName)
            updateButtonAppearance()
        }
    }
    
    init(currentWeapon: Weapon) {
        self._currentWeapon = currentWeapon
        self.currentWeaponTexture = SKTexture(imageNamed: currentWeapon.weaponName)
        
        super.init(texture: backgroundTexture, color: .clear, size: backgroundTexture.size())
        
        self.name = "weaponSlotButton"
        
        updateButtonAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTexture(with weapon: Weapon?) {
        print("updateTexture")
        if let weapon = weapon {
            currentWeapon = weapon
        } else {
            currentWeapon = _currentWeapon
        }
    }
    
    private func updateButtonAppearance() {
        print("updateButtonAppearance")
        // Ensure the background texture is set
        self.texture = backgroundTexture

        // Check if the weapon node already exists
        if let weaponNode = self.childNode(withName: "weaponTexture") as? SKSpriteNode {
            // Update the texture of the existing node
            weaponNode.texture = currentWeaponTexture
        } else {
            // Create a new weapon node if it doesn't exist
            if let weaponTexture = currentWeaponTexture {
                let weaponNode = SKSpriteNode(texture: weaponTexture, color: .clear, size: CGSize(width: 40, height: 40))
                weaponNode.zPosition = 1
                weaponNode.name = "weaponTexture"
                weaponNode.position = CGPoint(x: 0, y: 0)
                self.addChild(weaponNode)
            }
        }
    }
}
