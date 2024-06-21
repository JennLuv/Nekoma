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
        
//        addChild(hpBarBackground)
//        addChild(hpBarForeground)
        
        self.updateHPBar()
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
        self.isAttacked = true
        self.hp -= damage
        self.ariseAnimation()
        self.displayLives()
        self.updateHPBar()
        
        if hp <= 0 {
            self.dieAnimation()
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.freezeScene()
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isAttacked = false
                self.removeLivesBar()
            }
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
    
    func dieAnimation() {
        let playerFrames: [SKTexture] = [
            SKTexture(imageNamed: "playerDeath0"),
            SKTexture(imageNamed: "playerDeath1"),
            SKTexture(imageNamed: "playerDeath2"),
        ]
        self.animate(frames: playerFrames, timePerFrame: 0.1, isRepeatForever: false)
    }
    
    func displayLives() {
        guard self.hp > 0 else {
            return
        }
        self.removeLivesBar()
        
        let heartSpacing: CGFloat = 5
        let heartSize: CGFloat = 30
        
        for i in 0..<self.hp {
            let heart = SKSpriteNode(imageNamed: "heart2")
            heart.physicsBody = nil
            heart.setScale(0.4)

            let row = i < self.hp / 2 ? 0 : 1
            let column = i < self.hp / 2 ? i : i - self.hp / 2
            
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
        guard !livesBar.isEmpty else { return }
        let animation = SKAction.animate(with: heartBreakFrames, timePerFrame: 0.2)
        livesBar.last?.run(animation)
    }
    
    func removeLivesBar() {
        for heart in livesBar {
            heart.removeFromParent()
        }
        livesBar.removeAll()
    }
    
    private func freezeScene() {
        guard let scene = self.scene else { return }
        scene.isPaused = true
        scene.physicsWorld.speed = 0
        scene.enumerateChildNodes(withName: "//.*") { node, _ in
            node.isPaused = true
        }
    }
}
