//
//  Chest.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 19/06/24.
//

import SpriteKit

enum RarityLevel: String {
    case common, uncommon, rare
}

enum ChestContent {
    case single(ChestContentType), multiple([ChestContentType])
}

enum ChestContentType {
    case weapon(Weapon), fish(Fish)
}

class Chest: SKSpriteNode {
    let id: Int
    let content: ChestContent?
    var currentLevel: Int?
    var isOpened: Bool = false
   
    static let chestNormalTextureAtlas = SKTextureAtlas(named: "chestNormal")
    static let chestSpecialTextureAtlas = SKTextureAtlas(named: "chestSpecial")
    static let indicatorTextureAtlas = SKTextureAtlas(named: "openChestIndicator")
    
    static let levelConfig: [Int: (roomsWithChest: Int, filledChests: Int, bossAppear: Bool)] = [
        1: (roomsWithChest: 4, filledChests: 2, bossAppear: false),
        2: (roomsWithChest: 5, filledChests: 2, bossAppear: false),
        3: (roomsWithChest: 6, filledChests: 3, bossAppear: false),
        4: (roomsWithChest: 7, filledChests: 3, bossAppear: false),
        5: (roomsWithChest: 7, filledChests: 4, bossAppear: true)
    ]
    
    // MARK: Initialization
    init(id: Int, content: ChestContent?) {
        self.id = id
        self.content = content
        let texture: SKTexture
        
        switch content {
        case .multiple:
            texture = SKTexture(imageNamed: "chestSpecialClosed1")
        default:
            texture = SKTexture(imageNamed: "chestNormalClosed1")
        }
        
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Creating a Chest
    static func spawnChestNode(at position: CGPoint, room: Int, content: ChestContent?) -> Chest {
        print("spawnChestNode")
        let chest = Chest(id: room, content: content)
        chest.position = position
        chest.size = CGSize(width: 40, height: 40)
        chest.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 20, height: 10))
        chest.physicsBody?.isDynamic = false
        chest.physicsBody?.usesPreciseCollisionDetection = true
        chest.physicsBody?.categoryBitMask = PhysicsCategory.target
        chest.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        // Run chest animation
        if case .multiple = content {
            chest.run(createChestSpecialAnimation())
        } else {
            chest.run(createChestNormalAnimation())
        }
        
        return chest
    }
    
    static func createChestIndicator(at chest: Chest) -> SKSpriteNode {
        print("createChestIndicator")
        let indicatorNode = SKSpriteNode(imageNamed: "openChestIndicator1")
        indicatorNode.position = CGPoint(x: chest.position.x , y: chest.position.y + 20)
        indicatorNode.size = CGSize(width: indicatorNode.size.width / 4, height: indicatorNode.size.height / 4)
        indicatorNode.run(createChestIndicatorAnimation())
        
        let moveUp = SKAction.moveBy(x: 0, y: 7, duration: 0.5)
        let moveDown = SKAction.moveBy(x: 0, y: -7, duration: 0.5)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let upAndDownMotion = SKAction.repeatForever(sequence)
        indicatorNode.run(upAndDownMotion)
        
        return indicatorNode
    }
    
    // MARK: Animating Chest (Shiny, Shimmering, Splendid)
    static func changeTextureToOpened(chestNode: Chest) {
        print("changeTextureToOpened")
        chestNode.isOpened = true
        if case .multiple = chestNode.content {
            chestNode.texture = SKTexture(imageNamed: "chestSpecialOpened")
        } else {
            chestNode.texture = SKTexture(imageNamed: "chestNormalOpened")
        }
        chestNode.removeAllActions()
    }
    
    static func createChestNormalAnimation() -> SKAction {
        print("createChestNormalAnimation")
        var chestFrames: [SKTexture] = []
        for i in 1...5 {
            let textureName = "chestNormalClosed\(i)"
            chestFrames.append(chestNormalTextureAtlas.textureNamed(textureName))
        }
        return SKAction.repeatForever(SKAction.animate(with: chestFrames, timePerFrame: 0.2))
    }
    
    static func createChestNormalVoidAnimation() -> SKAction {
        print("createChestNormalVoidAnimation")
        var chestFrames: [SKTexture] = []
        for i in 1...7 {
            let textureName = "chestNormalVoid\(i)"
            chestFrames.append(chestNormalTextureAtlas.textureNamed(textureName))
        }
        return SKAction.animate(with: chestFrames, timePerFrame: 0.2)
    }
    
    static func createChestSpecialAnimation() -> SKAction {
        print("createChestSpecialAnimation")
        var chestFrames: [SKTexture] = []
        for i in 1...4 {
            let textureName = "chestSpecialClosed\(i)"
            chestFrames.append(chestSpecialTextureAtlas.textureNamed(textureName))
        }
        return SKAction.animate(with: chestFrames, timePerFrame: 0.2)
    }
    
    static func createChestIndicatorAnimation() -> SKAction {
        print("createChestIndicatorAnimation")
        var indicatorFrames: [SKTexture] = []
        for i in 1...2 {
            let textureName = "openChestIndicator\(i)"
            indicatorFrames.append(indicatorTextureAtlas.textureNamed(textureName))
        }
        return SKAction.repeatForever(SKAction.animate(with: indicatorFrames, timePerFrame: 0.5))
    }

    // MARK: Generating Chest For All Rooms in a Level
    func generateChests(level: Int) -> [Chest] {
        print("generateChests")
        guard let config = Chest.levelConfig[level] else {
            print("Level unavailable")
            return []
        }
        
        self.currentLevel = level
        
        return distributeChestsToRooms(roomsWithChest: config.roomsWithChest, filledChests: config.filledChests, bossAppear: config.bossAppear)
    }

    func distributeChestsToRooms(roomsWithChest: Int, filledChests: Int, bossAppear: Bool) -> [Chest] {
        print("distributeChestsToRooms")
        var chestPlacement: [Chest] = []
        var chestLeft: Int = filledChests
        var chestContent: ChestContent?
        
        for roomNumber in 1...roomsWithChest {
            chestContent = nil
            if roomNumber == roomsWithChest {
                if bossAppear {
                    chestContent = .multiple([getWeapon(rarityValue: .rare)!, getFish(rarityValue: .rare)!])
                } else {
                    chestContent = .single(getChestContent(lastRoom: true)!)
                }
                chestLeft -= 1
            } else if chestLeft > 1 {
                if roomNumber % 2 == 0 {
                    chestContent = .single(getChestContent(lastRoom: false)!)
                    chestLeft -= 1
                }
            }
            chestPlacement.append(Chest(id: roomNumber, content: chestContent))
        }
        
        // For printing result, gonna delete later
        for item in chestPlacement {
            if let content = item.content {
                switch content {
                case .single(let type):
                    switch type {
                    case .fish(let fish):
                        print("Chest \(item.id): ContentType: Fish, Name: \(fish.fishName)")
                    case .weapon(let weapon):
                        print("Chest \(item.id): ContentType: Weapon, Name: \(weapon.weaponName)")
                    }
                case .multiple(let types):
                    for type in types {
                        switch type {
                        case .fish(let fish):
                            print("Chest \(item.id): ContentType: Fish, Name: \(fish.fishName)")
                        case .weapon(let weapon):
                            print("Chest \(item.id): ContentType: Weapon, Name: \(weapon.weaponName)")
                        }
                    }
                }
            } else {
                print("Chest \(item.id): Empty")
            }
        }
        
        return chestPlacement
    }
    
    func getChestContent(lastRoom: Bool) -> ChestContentType? {
        print("getChestContent")
        let randomValue = Float.random(in: 0...1)
        let rarityValue = getRarity()
        let chance: Float = {
            return lastRoom ? 0.1 : 0.8
        }()
        
        if randomValue <= chance {
            return getWeapon(rarityValue: rarityValue)
        } else {
            return getFish(rarityValue: rarityValue)
        }
    }
    
    func getRarity() -> RarityLevel? {
        print("getRarity")
        let randomValue = Float.random(in: 0...1)
        let modifier = Float(self.currentLevel!)
        if randomValue <= (0.1 * modifier - max(0 , 0.05 * (modifier - 1))) {
            return .rare
        } else if randomValue > (0.1 * modifier - max(0 , 0.05 * (modifier - 1))) && randomValue <= (0.3 + 0.1 * (modifier)) {
            return .uncommon
        } else {
            return .common
        }
    }
    
    func getWeapon(rarityValue: RarityLevel?) -> ChestContentType? {
        print("getWeapon")
        let filteredWeapons = Weapon.allWeapons().filter { $0.rarity == rarityValue }
        if let randomWeapon = filteredWeapons.randomElement() {
            return .weapon(randomWeapon)
        }
        return nil
    }
    
    func getFish(rarityValue: RarityLevel?) -> ChestContentType? {
        print("getFish")
        let filteredFish = Fish.allFishes().filter { $0.rarity == rarityValue }
        if let randomFish = filteredFish.randomElement() {
            return .fish(randomFish)
        }
        return nil
    }
    
    // MARK: Spawning Weapon When Chest is Opened
    func spawnContent() {
        print("spawnContent")
        guard let content = self.content else { return }
        switch content {
        case .single(let contentType):
            spawn(contentType)
        case .multiple(let contentTypes):
            spawnMultiple(contentTypes)
        }
    }

    private func spawn(_ contentType: ChestContentType) {
        print("spawn")
        switch contentType {
        case .weapon(let weapon):
            spawnWeapon(weapon, xCoordinate: 0, yCoordinate: -20)
        case .fish(let fish):
            spawnFish(fish, xCoordinate: 0, yCoordinate: -20)
        }
    }
    
    private func spawnMultiple(_ contentTypes: [ChestContentType]){
        print("spawnMultiple")
        for contentType in contentTypes{
            switch contentType {
            case .weapon(let weapon):
                spawnWeapon(weapon, xCoordinate: -20, yCoordinate: -20)
            case .fish(let fish):
                spawnFish(fish, xCoordinate: 20, yCoordinate: -20)
            }
        }
    }

    private func spawnWeapon(_ weapon: Weapon, xCoordinate: CGFloat, yCoordinate: CGFloat) {
        print("spawnWeapon")
        let weaponNode = Weapon(imageName: weapon.imageName, weaponName: weapon.weaponName, rarity: weapon.rarity, projectileName: weapon.projectileName, attack: weapon.attack, category: weapon.category)
        weaponNode.position = CGPoint(x: self.position.x + xCoordinate, y: self.position.y + yCoordinate)
        let originalSize = weaponNode.size
        weaponNode.size = CGSize(width: originalSize.width / 2, height: originalSize.height / 2)
        self.parent?.addChild(weaponNode)
    }
    
    private func spawnFish(_ fish: Fish, xCoordinate: CGFloat, yCoordinate: CGFloat) {
        print("spawnFish")
        let fishNode = Fish(imageName: fish.imageName, fishName: fish.fishName, bonusLives: fish.bonusLives, bonusAttack: fish.bonusAttack, bonusSpeed: fish.bonusSpeed, specialPower: fish.specialPower, rarity: fish.rarity)
        fishNode.position = CGPoint(x: self.position.x + xCoordinate, y: self.position.y + yCoordinate)
        let originalSize = fishNode.size
        fishNode.size = CGSize(width: originalSize.width / 2, height: originalSize.height / 2)
        self.parent?.addChild(fishNode)
    }
}


