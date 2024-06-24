import SpriteKit

class Enemy2: SKSpriteNode {
    var hp: Int {
        didSet {
            updateHPBar()
        }
    }
    var maxHP: Int
    var attackSpeed: Float
    var range: CGPoint
    private let hpBarBackground: SKSpriteNode
    private let hpBarForeground: SKSpriteNode
    
    init(hp: Int, imageName: String, maxHP: Int, name: String, speed: CGFloat, attackSpeed: Float, range: CGPoint, scale: CGFloat) {
        self.hp = hp
        self.maxHP = maxHP
        self.attackSpeed = attackSpeed
        self.range = range
        let texture = SKTexture(imageNamed: imageName)
        
        self.hpBarBackground = SKSpriteNode(color: .gray, size: CGSize(width: 30, height: 3))
        self.hpBarForeground = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 3))
        
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = name
        self.setScale(scale)
        self.setupPhysicsBody(texture: texture)
        self.setupHealthbar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHealthbar() {
        // Configure the HP bar
        hpBarBackground.position = CGPoint(x: 0, y: size.height / 2 )
        hpBarForeground.position = CGPoint(x: 0, y: size.height / 2 )
        addChild(hpBarBackground)
        addChild(hpBarForeground)
        updateHPBar()
    }
    
    private func setupPhysicsBody(texture: SKTexture) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy
    }
    
    func chasePlayer(player: SKSpriteNode) {
        let playerPosition = player.position
        let dx = playerPosition.x - position.x
        let dy = playerPosition.y - position.y
        let angle = atan2(dy, dx)
        
        let speed: CGFloat = 20.0
        let vx = cos(angle) * speed
        let vy = sin(angle) * speed
        self.physicsBody?.velocity = CGVector(dx: vx, dy: vy)
    }
    
    func animate(frames: [SKTexture], timePerFrame: TimeInterval, isRepeated:Bool) {
        let animation = SKAction.animate(with: frames, timePerFrame: timePerFrame)
        if isRepeated {
            let repeatAction = SKAction.repeatForever(animation)
            self.run(repeatAction)
        } else {
            self.run(animation)
        }
        
    }
    
    func spawnInScene(scene: SKScene, atPosition position: CGPoint) {
        self.position = position
        scene.addChild(self)
    }
    
    func takeDamage(_ damage: Int) {
        hp -= damage
        updateHPBar()
        // TODO: Do something about the room logic
        // Or even the jail down logic
        // Otherwise can't play animation
        // Temp fix: remove enemy death animation
        // TODO: Inos bawa krimer andin dan charger brendan 😏
        if hp < 1 {
            self.removeFromParent()
        }
    }
    private func updateHPBar() {
        let hpRatio = CGFloat(hp) / CGFloat(maxHP)
        hpBarForeground.size.width = hpBarBackground.size.width * hpRatio
        hpBarForeground.position = CGPoint(x: -hpBarBackground.size.width / 2 + hpBarForeground.size.width / 2, y: hpBarBackground.position.y)
    }
}

class MeleeEnemy: Enemy2 {
    var isAttacking: Bool = false
    
    init(name: String) {
        let scale: CGFloat = 1.7
        super.init(hp: 5, imageName: "Melee", maxHP: 5, name: name, speed: 1.0, attackSpeed: 10, range: CGPoint(x:10, y:10), scale: scale)
        self.walkAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walkAnimation() {
        let meleeFrames: [SKTexture] = [
            SKTexture(imageNamed: "meleeWalk0"),
            SKTexture(imageNamed: "meleeWalk1"),
            SKTexture(imageNamed: "meleeWalk2"),
            SKTexture(imageNamed: "meleeWalk3"),
        ]
        self.animate(frames: meleeFrames, timePerFrame: 0.1, isRepeated: true)
    }
    
    func hurtAnimation() {
        let meleeFrames: [SKTexture] = [
            SKTexture(imageNamed: "meleeHurt0"),
            SKTexture(imageNamed: "meleeHurt1"),
        ]
        self.animate(frames: meleeFrames, timePerFrame: 0.2, isRepeated: false)
    }
    
    func dieAnimation() {
        let meleeFrames: [SKTexture] = [
            SKTexture(imageNamed: "meleeDie0"),
            SKTexture(imageNamed: "meleeDie1"),
            SKTexture(imageNamed: "meleeDie2"),
            SKTexture(imageNamed: "meleeDie3"),
            SKTexture(imageNamed: "meleeDie4")
        ]
        self.animate(frames: meleeFrames, timePerFrame: 0.2, isRepeated: false)
    }
    
    override func chasePlayer(player: SKSpriteNode) {
        super.chasePlayer(player: player)
        if !isAttacking {
            let dx = player.position.x - self.position.x
            if dx > 0 {
                self.xScale = abs(self.xScale)
            } else {
                self.xScale = -abs(self.xScale)
            }
            
            let distance = hypotf(Float(self.position.x - player.position.x), Float(self.position.y - player.position.y))
            if distance < 20 && self.hp > 0 {
                isAttacking = true
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    self.isAttacking = false
                }
                self.meleeAttack(player: player)
                if let playerAttacked = player as? Player2 {
                    playerAttacked.takeDamage(1)
                }
            }
        } else {
            self.physicsBody?.velocity = CGVector(dx:0, dy:0)
        }
    }
    
    override func takeDamage(_ damage: Int) {
        super.takeDamage(damage)
        if self.hp < 1 {
            let collisionAction = SKAction.run {
                self.physicsBody = nil
                self.removeFromParent()
            }
            
            let dieAnimation = SKAction.run {
                self.dieAnimation()
            }
            
            let delayAction = SKAction.wait(forDuration: 1.0)
            let actions = [dieAnimation, delayAction, collisionAction]
            
            self.run(SKAction.sequence(actions))
        } else {
            self.hurtAnimation()
        }
    }
    
    func meleeAttack(player: SKSpriteNode) {
        let attackFrames: [SKTexture] = [
            SKTexture(imageNamed: "meleeAttack0"),
            SKTexture(imageNamed: "meleeAttack1"),
            SKTexture(imageNamed: "meleeAttack2"),
            SKTexture(imageNamed: "meleeAttack3"),
            SKTexture(imageNamed: "meleeAttack4"),
            SKTexture(imageNamed: "meleeAttack5"),
        ]
        self.animate(frames: attackFrames, timePerFrame: 0.1, isRepeated: true)
    }
}

class RangedEnemy: Enemy2 {
    private var isShooting = false
    
    init(name: String) {
        let scale: CGFloat = 2.0
        super.init(hp: 5, imageName: "Ranged", maxHP: 5, name: name, speed: 0.4, attackSpeed: 20, range: CGPoint(x:20, y:20), scale: scale)
        self.walkAnimation()
    }
    
    required init?(coder aDecoder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walkAnimation() {
        let rangedFrames: [SKTexture] = [
            SKTexture(imageNamed: "rangedWalk0"),
            SKTexture(imageNamed: "rangedWalk1"),
            SKTexture(imageNamed: "rangedWalk2"),
            SKTexture(imageNamed: "rangedWalk3"),
            SKTexture(imageNamed: "rangedWalk4"),
        ]
        self.animate(frames: rangedFrames, timePerFrame: 0.1, isRepeated: true)
    }
    
    func hurtAnimation() {
        let rangedFrames: [SKTexture] = [
            SKTexture(imageNamed: "rangedHurt0"),
            SKTexture(imageNamed: "rangedHurt1"),
        ]
        self.animate(frames: rangedFrames, timePerFrame: 0.2, isRepeated: false)
    }
    
    func dieAnimation() {
        let rangedFrames: [SKTexture] = [
            SKTexture(imageNamed: "rangedDie0"),
            SKTexture(imageNamed: "rangedDie1"),
            SKTexture(imageNamed: "rangedDie2"),
            SKTexture(imageNamed: "rangedDie3"),
            SKTexture(imageNamed: "rangedDie4"),
            SKTexture(imageNamed: "rangedDie5")
        ]
        self.animate(frames: rangedFrames, timePerFrame: 0.2, isRepeated: false)
    }
    
    override func chasePlayer(player: SKSpriteNode) {
        super.chasePlayer(player: player)
        let dx = player.position.x - self.position.x
        if dx > 0 {
            self.xScale = -abs(self.xScale)
        } else {
            self.xScale = abs(self.xScale)
        }
    }
    
    override func takeDamage(_ damage: Int) {
        super.takeDamage(damage)
        if self.hp < 1 {
            let collisionAction = SKAction.run {
                self.physicsBody = nil
                self.removeFromParent()
            }
            
            let dieAnimation = SKAction.run {
                self.dieAnimation()
            }
            
            let delayAction = SKAction.wait(forDuration: 1.0)
            let actions = [dieAnimation, delayAction, collisionAction]
            
            self.run(SKAction.sequence(actions))
        } else {
            self.hurtAnimation()
        }
    }
    
    func shootBullet(player: SKSpriteNode, scene: SKScene) {
        guard !isShooting && hp > 0 else {
            return // prevent rapid shooting
        }
        
        isShooting = true
        
        let bulletTexture = SKTexture(imageNamed: "rangedBullet5")
        let bullet = SKSpriteNode(texture: bulletTexture)
        bullet.setScale(0.5)
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.enemyProjectile
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.player
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.none
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        let collisionAction = SKAction.run {
            bullet.removeFromParent()
            self.isShooting = false
        }
        
        let delayAction = SKAction.wait(forDuration: 1.0)
        let actions = [delayAction, collisionAction]
        bullet.run(SKAction.sequence(actions))
        scene.addChild(bullet)
        
        let dx = player.position.x - self.position.x
        let dy = player.position.y - self.position.y
        let angle = atan2(dy, dx)
        
        bullet.position = CGPoint(x: dx > 0 ? self.position.x+16 : self.position.x-16, y: self.position.y-6)

        let speed:CGFloat = self.speed * 100.0
        let vx = cos(angle) * speed
        let vy = sin(angle) * speed
        
        bullet.physicsBody?.velocity = CGVector(dx: vx, dy: vy)
    }
    
    
}
