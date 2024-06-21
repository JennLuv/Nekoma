//
//  Player2.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 17/06/24.
//

import SpriteKit

let defaultWeapon = Weapon(imageName: "laserPointer", weaponName: "laserPointer", rarity: .common)
let defaultFish = Fish(imageName: "salmonCommon", fishName: "salmonCommon", bonusLives: 0, bonusAttack: 0.1, bonusSpeed: 0, specialPower: SpecialPower(name: "Salmon Leap", cooldown: 100), rarity: .common)

class Player2: SKSpriteNode {
    var hp: Int {
        didSet {
            updateHPBar()
        }
    }
    var maxHP: Int
    var equippedWeapon: Weapon
    var equippedFish: Fish
    private let hpBarBackground: SKSpriteNode
    private let hpBarForeground: SKSpriteNode
    private var livesBar: [SKSpriteNode] = []
    
    var isAttacked = false

    init(hp: Int, imageName: String, maxHP: Int, name: String) {
        self.hp = hp
        self.maxHP = maxHP
        let texture = SKTexture(imageNamed: imageName)
        
        self.hpBarBackground = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 5))
        self.hpBarForeground = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 5))
        
        self.equippedWeapon = defaultWeapon
        self.equippedFish = defaultFish
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = name
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.isDynamic = true
        
        self.position = CGPoint(x: 0, y: 0)
        self.setScale(0.55)
        
        // Configure the HP bar
        hpBarBackground.position = CGPoint(x: 0, y: size.height / 2 + 15)
        hpBarForeground.position = CGPoint(x: 0, y: size.height / 2 + 15)
        
        addChild(hpBarBackground)
        addChild(hpBarForeground)
        
        updateHPBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func spawnInScene(scene: SKScene, atPosition position: CGPoint) {
        self.position = position
        scene.addChild(self)
    }

    func takeDamage(_ damage: Int) {
        if isAttacked {
            return
        }
        isAttacked = true
        hp -= damage
        ariseAnimation()
        displayLives()
        updateHPBar()
        
        if hp <= 0 {
            self.removeFromParent()
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.isAttacked = false
        }
    }

    private func updateHPBar() {
        let hpRatio = CGFloat(hp) / CGFloat(maxHP)
        hpBarForeground.size.width = hpBarBackground.size.width * hpRatio
        hpBarForeground.position = CGPoint(x: -hpBarBackground.size.width / 2 + hpBarForeground.size.width / 2, y: hpBarBackground.position.y)
    }
    
    func animate(frames: [SKTexture], timePerFrame: TimeInterval, isRepeatForever: Bool) {
        let animation = SKAction.animate(with: frames, timePerFrame: timePerFrame)
        if isRepeatForever {
            let repeatAction = SKAction.repeatForever(animation)
            self.run(repeatAction)
        } else {
            self.run(animation)
        }
    }
    
    func ariseAnimation() {
        let playerFrames: [SKTexture] = [
            SKTexture(imageNamed: "playerBlessed0"),
            SKTexture(imageNamed: "playerBlessed1"),
            SKTexture(imageNamed: "playerBlessed2"),
            SKTexture(imageNamed: "playerBlessed3"),
            SKTexture(imageNamed: "playerBlessed4"),
            SKTexture(imageNamed: "playerBlessed5"),
            SKTexture(imageNamed: "playerBlessed6"),
            SKTexture(imageNamed: "playerBlessed7"),
            SKTexture(imageNamed: "playerBlessed8"),
        ]
        self.animate(frames: playerFrames, timePerFrame: 0.1, isRepeatForever: false)
    }
    
    func displayLives() {
        self.removeLivesBar()
        
        let heartSpacing: CGFloat = 5
        let heartSize: CGFloat = 30
        
        for i in 0..<9 {
            let heart = SKSpriteNode(imageNamed: "heart2")
            heart.physicsBody = nil
            heart.setScale(0.4)

            let row = i < 4 ? 0 : 1
            let column = i < 4 ? i : i - 4
            
            let totalWidthTopRow = (heartSize + heartSpacing) * 4 - heartSpacing
            let totalWidthBottomRow = (heartSize + heartSpacing) * 5 - heartSpacing
            let offsetXTopRow = -totalWidthTopRow / 2 + heartSize / 2
            let offsetXBottomRow = -totalWidthBottomRow / 2 + heartSize / 2
            

            let xPosition = row == 0 ? offsetXTopRow + CGFloat(column) * (heartSize + heartSpacing) : offsetXBottomRow + CGFloat(column) * (heartSize + heartSpacing)
            let yPosition = size.height / 2 + 30 + CGFloat(row) * (heartSize + heartSpacing)
            
            heart.position = CGPoint(x: xPosition, y: yPosition)
            
            self.livesBar.append(heart)
            addChild(heart)
        }
        heartBreak()
    }
    
    func heartBreak() {
        let heartBreakFrames = [
            SKTexture(imageNamed: "heart2"),
            SKTexture(imageNamed: "heart3"),
            SKTexture(imageNamed: "heart4"),
            SKTexture(imageNamed: "heart5"),
            SKTexture(imageNamed: "heart6"),
        ]
        
        let heartsToBreak = max(0, 9 - self.hp)
        
        for (i, heart) in livesBar.enumerated() {
            if i < heartsToBreak {
                let animation = SKAction.animate(with: heartBreakFrames, timePerFrame: 0.2)
                heart.run(animation)
            }
        }
        
        let delayAction = SKAction.wait(forDuration: 1.0)
        let removeLivesBarAction = SKAction.run { [weak self] in
            self?.removeLivesBar()
        }
        let sequence = SKAction.sequence([delayAction, removeLivesBarAction])
        self.run(sequence)
    }
    
    func removeLivesBar() {
        for heart in livesBar {
            heart.removeFromParent()
        }
        livesBar.removeAll()
    }
}
