//
//  DungeonRoomViewModel.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 10/06/24.
//

import Foundation
import SpriteKit
import GameController

class DungeonScene: SKScene, SKPhysicsContactDelegate {
    var idCounter = 1
    var cameraNode: SKCameraNode!
    
    //Joystick
    let player = SKSpriteNode(imageNamed: "player")
    var virtualController: GCVirtualController?
    var playerPosx: CGFloat = 0
    var playerPosy: CGFloat = 0
    //end
    
    // Movement
    var playerMovedLeft = false
    var playerMovedRight = false
    var playerLooksLeft = false
    var playerLooksRight = true
    
    var playerWalkFrames = [SKTexture]()
    var playerIdleFrames = [SKTexture]()
    var playerWalkTextureAtlas = SKTextureAtlas(named: "playerWalk")
    var playerIdleTextureAtlas = SKTextureAtlas(named: "playerIdle")
    var playerIsMoving = false
    var playerStartMoving = false
    var playerStopMoving = true
    
    // Attacks
    var playerIsShooting = false
    var playerIsAttacking = false
    
    // Enemies
    var enemies: [Enemy] = []
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        setupCamera()
        let rooms = generateLevel(roomCount: 9)
        print(rooms)
        drawDungeon(rooms: rooms)
        //        drawSpecialDungeon()
         
        //Spawn enemy after 5secs
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.spawnEnemies(in: rooms)
        }
        
        // Joystick
        scene?.anchorPoint = .zero
        
        player.position = CGPoint(x: 0, y: 0)
        player.setScale(0.55)
        
        // Set up physics body for the player
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = false
        
        //MARK: Player Physics
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.collisionBitMask = PhysicsCategory.player
        
        for i in 0..<playerWalkTextureAtlas.textureNames.count {
            let textureNames = "playerWalk" + String(i)
            playerWalkFrames.append(playerWalkTextureAtlas.textureNamed(textureNames))
        }
        
        for i in 0..<playerIdleTextureAtlas.textureNames.count {
            let textureNames = "playerIdle" + String(i)
            playerIdleFrames.append(playerIdleTextureAtlas.textureNamed(textureNames))
        }
        
        addChild(player)
        
        connectVirtualController()
        
        // end
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask == PhysicsCategory.projectile ? contact.bodyB : contact.bodyA
        
        if collision.categoryBitMask == PhysicsCategory.target{
            if contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
        }
        
        let collision2 = contact.bodyA.categoryBitMask == PhysicsCategory.enemy ? contact.bodyB : contact.bodyA
        
        if collision2.categoryBitMask == PhysicsCategory.projectile{
            if contact.bodyA.categoryBitMask == PhysicsCategory.enemy {
                if let oldHp = contact.bodyA.node?.userData?.value(forKey: "hp") as? Int {
                    contact.bodyA.node?.userData?.setValue(oldHp - 1, forKey: "hp")
                    if oldHp - 1 <= 0 {
                        contact.bodyA.node?.removeFromParent()
                    }
                    contact.bodyB.node?.removeFromParent()
                }
            } 
        }
    }
    
    //Joystick
    
    override func update(_ currentTime: TimeInterval) {
        if let thumbstick = virtualController?.controller?.extendedGamepad?.leftThumbstick {
            let playerPosx = CGFloat(thumbstick.xAxis.value)
            let playerPosy = CGFloat(thumbstick.yAxis.value)
            
            let movementSpeed: CGFloat = 3.0
            
            player.physicsBody?.velocity = CGVector(dx: playerPosx * movementSpeed * 60, dy: playerPosy * movementSpeed * 60)
            player.physicsBody?.allowsRotation = false
            
            if let v = player.physicsBody?.velocity {
                if v == CGVector(dx:0, dy:0) {
                    if playerIsMoving == true {
                        playerStopMoving = true
                    }
                    playerIsMoving = false
                } else {
                    if playerIsMoving == false {
                        playerStartMoving = true
                    }
                    playerIsMoving = true
                }
            }
            
            if playerStartMoving {
                playerStartMoving = false
                player.removeAllActions()
                player.run(SKAction.repeatForever(SKAction.animate(with: playerWalkFrames, timePerFrame: 0.1)))
                print("Start Moving")
            }
            if playerStopMoving {
                playerStopMoving = false
                player.removeAllActions()
                player.run(SKAction.repeatForever(SKAction.animate(with: playerIdleFrames, timePerFrame: 0.2)))
                print("Stop Moving")
            }
            
            if playerPosx > 0 {
                playerMovedRight = true
            } else {
                playerMovedRight = false
            }
            
            if playerPosx < 0 {
                playerMovedLeft = true
            } else {
                playerMovedLeft = false
            }
            
            if playerMovedLeft == true && playerLooksRight == true {
                player.xScale = -player.xScale
                playerLooksRight = false
                playerLooksLeft = true
            }
            
            if playerMovedRight == true && playerLooksLeft == true {
                player.xScale = -player.xScale
                playerLooksLeft = false
                playerLooksRight = true
            }
            
            cameraNode.position = player.position
        }
        
        if let buttonA = virtualController?.controller?.extendedGamepad?.buttonA, buttonA.isPressed {
            shootImage()
        }
        
        if let buttonB = virtualController?.controller?.extendedGamepad?.buttonB, buttonB.isPressed {
            meleeAttack()
        }

        //Update enemy position to chase player
        for enemy in enemies {
            enemy.chasePlayer(player: player)
        }
        
    }
    
    func meleeAttack() {
        let attackSpeed = 0.3
        let weaponRange = 2
        if playerIsAttacking {
            return
        }
        playerIsAttacking = true
        
        var direction = 1
        if playerLooksLeft {
            direction = -1
        }
        
        let hitbox = SKSpriteNode(imageNamed: "player")
        hitbox.xScale = CGFloat(direction)
        hitbox.position = CGPoint(x: player.position.x + CGFloat(30 * direction), y: player.position.y)
        hitbox.size = CGSize(width: 36 * weaponRange, height: 36 * weaponRange)
        hitbox.physicsBody = SKPhysicsBody(rectangleOf: hitbox.size)
        hitbox.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        hitbox.physicsBody?.collisionBitMask = PhysicsCategory.projectile
        hitbox.physicsBody?.contactTestBitMask = PhysicsCategory.target
        hitbox.physicsBody?.affectedByGravity = false
        
        self.addChild(hitbox)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            hitbox.removeFromParent()
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + attackSpeed) {
            self.playerIsAttacking = false
        }
    }
    
    func shootImage() {
        let attackSpeed = 0.3
        let projectileSpeed = 100
        if playerIsShooting {
            return
        }
        playerIsShooting = true
        
        var direction = 1
        if playerLooksLeft {
            direction = -1
        }
        
        let projectile = SKSpriteNode(imageNamed: "player")
        projectile.position = player.position
        projectile.size = CGSize(width: 20, height: 20)
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.velocity = CGVector(dx: direction * projectileSpeed, dy: 0)
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.target
        projectile.physicsBody?.affectedByGravity = false
        
        self.addChild(projectile)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + attackSpeed) {
            self.playerIsShooting = false
        }
        
    }

    func randomPosition(in room: Room) -> CGPoint {
        
        // Define the range for x and y within the room's bounds
        let minX = room.position.x - (36*5)
        let maxX = room.position.x + (36*5)
        let minY = room.position.y - (36*5)
        let maxY = room.position.y + (36*5)

        // Generate random x and y within the defined range
        let x = CGFloat.random(in: CGFloat(minX)..<CGFloat(maxX))
        let y = CGFloat.random(in: CGFloat(minY)..<CGFloat(maxY))

        // Return the random position within the room's bounds
        return CGPoint(x: x, y: y)
    }

    func spawnEnemies(in rooms: [Room]) {
        for room in rooms {
            for _ in 0..<Int.random(in: 3...4) {
                // Spawn melee enemy
                let meleeEnemy = MeleeEnemy()
                meleeEnemy.position = randomPosition(in: room)
                meleeEnemy.chasePlayer(player: player)
                addChild(meleeEnemy)
                enemies.append(meleeEnemy)
            
            }
            for _ in 0..<Int.random(in: 0...2) {
                // Spawn ranged enemy
                let rangedEnemy = RangedEnemy()
                rangedEnemy.position = randomPosition(in: room)
                rangedEnemy.chasePlayer(player: player)
                addChild(rangedEnemy)
                enemies.append(rangedEnemy)
            }
        }
    }
    
    func connectVirtualController() {
        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [GCInputLeftThumbstick, GCInputButtonA, GCInputButtonB]
        
        let controller = GCVirtualController(configuration: controllerConfig)
        controller.connect()
        virtualController = controller
    }
    //end
    
    func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        cameraNode.setScale(0.8)
        addChild(cameraNode)
    }
    
    func drawDungeon(rooms: [Room]) {
        for room in rooms {
            let roomNode = SKSpriteNode(imageNamed: room.getRoomImage().imageName)
            roomNode.position = room.position
            
            // For Bg
            let roomBgNode = SKSpriteNode(imageNamed: room.getRoomImage().bgName)
            roomBgNode.position = room.position
            
            let roomExtraNode = SKSpriteNode(imageNamed: room.getRoomImage().imageExtraName)
            roomExtraNode.position = room.position
            
            
            // Set up the physics body based on the room image
            roomNode.physicsBody = SKPhysicsBody(texture: roomNode.texture!, size: roomNode.size)
            roomNode.physicsBody?.isDynamic = false
            roomNode.physicsBody?.usesPreciseCollisionDetection = true
            roomNode.physicsBody?.categoryBitMask = PhysicsCategory.target
            roomNode.physicsBody?.collisionBitMask = PhysicsCategory.target
            roomNode.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
            
            //for extra image
            // Set up the physics body based on the room image
            roomExtraNode.physicsBody = SKPhysicsBody(texture: roomExtraNode.texture!, size: roomExtraNode.size)
            roomExtraNode.physicsBody?.isDynamic = false
            roomExtraNode.physicsBody?.usesPreciseCollisionDetection = true
            roomExtraNode.physicsBody?.categoryBitMask = PhysicsCategory.target
            roomExtraNode.physicsBody?.collisionBitMask = PhysicsCategory.target
            roomExtraNode.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
            
            addChild(roomBgNode)
            addChild(roomNode)
            addChild(roomExtraNode)

            let enemy1 = Enemy1(hp: 5, imageName: "player", maxHP: 5, name: "Enemy1")
            enemy1.spawnInScene(scene: self, atPosition: CGPoint(x: room.position.x + 100, y: room.position.y))

            let enemy2 = Enemy1(hp: 5, imageName: "player", maxHP: 5, name: "Enemy2")
            enemy2.spawnInScene(scene: self, atPosition: CGPoint(x: room.position.x - 100, y: room.position.y))

            let enemy3 = Enemy1(hp: 5, imageName: "player", maxHP: 5, name: "Enemy3")
            enemy3.spawnInScene(scene: self, atPosition: CGPoint(x: room.position.x, y: room.position.y + 100))

        }
    }
    
    func drawSpecialDungeon() {
        let roomSpecialNode = SKSpriteNode(imageNamed: "RoomSpecial")
        roomSpecialNode.position = CGPoint(x: 0, y: 0)
        
        let roomExtraSpecialNode = SKSpriteNode(imageNamed: "RoomExtraSpecial")
        roomExtraSpecialNode.position = CGPoint(x: 0, y: 0)
        
        let BgSpecialNode = SKSpriteNode(imageNamed: "BgSpecial")
        BgSpecialNode.position = CGPoint(x: 0, y: 0)
        
        roomSpecialNode.physicsBody = SKPhysicsBody(texture: roomSpecialNode.texture!, size: roomGridSize)
        roomSpecialNode.physicsBody?.isDynamic = false
        roomSpecialNode.physicsBody?.usesPreciseCollisionDetection = true
        roomSpecialNode.physicsBody?.categoryBitMask = PhysicsCategory.target
        roomSpecialNode.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        
        roomExtraSpecialNode.physicsBody = SKPhysicsBody(texture: roomExtraSpecialNode.texture!, size: roomGridSize)
        roomExtraSpecialNode.physicsBody?.isDynamic = false
        roomExtraSpecialNode.physicsBody?.usesPreciseCollisionDetection = true
        roomExtraSpecialNode.physicsBody?.categoryBitMask = PhysicsCategory.target
        roomExtraSpecialNode.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        
        addChild(BgSpecialNode)
        addChild(roomExtraSpecialNode)
        addChild(roomSpecialNode)
    }
    
    func getOppositeDirection(from direction: Direction) -> Direction {
        switch direction {
        case .Up:
            return .Down
        case .Down:
            return .Up
        case .Left:
            return .Right
        case .Right:
            return .Left
        }
    }
    
    func randomizeNextDirections(currentPosition: CGPoint, positionTaken: [PairInt: Bool], from: Direction, branch: Int ) -> [Direction] {
        var nextRoom: [Direction] = []
        
        var branches:[Direction] = [from]
        
        for _ in 0..<branch {
            var nextBranches = allDirection
            nextBranches = nextBranches.filter { !branches.contains($0!) }
            
            // let's also check whether the next branch's grid has been taken
            nextBranches = nextBranches.filter({
                switch $0 {
                case .Left:
                    return !(positionTaken[PairInt(first: Int(currentPosition.x - roomGridSize.width), second: Int(currentPosition.y))] ?? false)
                case .Right:
                    return !(positionTaken[PairInt(first: Int(currentPosition.x + roomGridSize.width), second: Int(currentPosition.y))] ?? false)
                case .Up:
                    return !(positionTaken[PairInt(first: Int(currentPosition.x), second: Int(currentPosition.y + roomGridSize.height))] ?? false)
                case .Down:
                    return !(positionTaken[PairInt(first: Int(currentPosition.x), second: Int(currentPosition.y - roomGridSize.height))] ?? false)
                case .none:
                    return false
                }
            })
            
            let nextBranch = (nextBranches.randomElement() ?? Direction(rawValue: "Up"))!
            branches.append(nextBranch)
            nextRoom.append(nextBranch)
        }
        
        return nextRoom
    }
    
    func generateLevel(roomCount: Int, catAppearance: Int? = nil) -> [Room] {
        // Grid Map
        var positionTaken: [PairInt: Bool] = [:]
        
        print("Generate level invoked")
        // Generate First Room
        let nextDirection = allDirection.randomElement()!
        let firstRoom = Room(id: idCounter, from: 0, toDirection: [nextDirection!], position: CGPoint(x: 0, y: 0))
        positionTaken[PairInt(first: 0, second: 0)] = true
        idCounter += 1
        
        var rooms = [firstRoom]
        var currentRoom = firstRoom
        
        for i in 2...roomCount {
            let nextDirections = currentRoom.toDirection
            // let's take one of the directions to make a room
            let nextDirection = nextDirections!.randomElement()
            // the next room is from the opposite
            let nextRoomFrom = getOppositeDirection(from: nextDirection!)
            
            let nextRoomTo: [Direction]?
            
            // let's calculate the position
            var nextRoomPosition: CGPoint = CGPoint(x: 0, y: 0)
            switch nextRoomFrom {
            case .Left:
                nextRoomPosition.x = currentRoom.position.x + roomGridSize.width
                nextRoomPosition.y = currentRoom.position.y
            case .Up:
                nextRoomPosition.x = currentRoom.position.x
                nextRoomPosition.y = currentRoom.position.y - roomGridSize.height
            case .Down:
                nextRoomPosition.x = currentRoom.position.x
                nextRoomPosition.y = currentRoom.position.y + roomGridSize.height
            case .Right:
                nextRoomPosition.x = currentRoom.position.x - roomGridSize.width
                nextRoomPosition.y = currentRoom.position.y
            }
            
            
            if i < roomCount {
                nextRoomTo = randomizeNextDirections(currentPosition:nextRoomPosition, positionTaken: positionTaken, from: nextRoomFrom, branch: 1)
            } else {
                nextRoomTo = nil
            }
            
            // create next room
            let nextRoom = Room(id: idCounter, from: currentRoom.id, fromDirection: nextRoomFrom, toDirection: nextRoomTo, position: nextRoomPosition)
            positionTaken[PairInt(first: Int(nextRoomPosition.x), second: Int(nextRoomPosition.y))] = true
            idCounter += 1
            
            // chain to current room
            currentRoom.to?.append(nextRoom.id)
            
            currentRoom = nextRoom
            rooms.append(nextRoom)
        }
        
        
        for room in rooms {
            let roomImage = room.getRoomImage()
            print("Room ID: \(room.id)")
            print("Room From: \(room.from)")
            print("Room To: \(room.to ?? [])")
            print("Room From Direction: \(room.fromDirection?.rawValue ?? "N/A")")
            print("Room To Direction: \(room.toDirection?.map { $0.rawValue } ?? [])")
            print("Room Image: \(roomImage)")
            print("Room Position: \(room.position)")
            print("------------------------------------")
        }
        return rooms
    }
    
}