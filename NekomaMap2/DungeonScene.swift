//
//  DungeonRoomViewModel.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 10/06/24.
//

import Foundation
import SpriteKit
import GameController

class DungeonScene: SKScene {
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
    
    override func didMove(to view: SKView) {
        setupCamera()
        let rooms = generateLevel(roomCount: 9)
        print(rooms)
        drawDungeon(rooms: rooms)
        
        // Joystick
        scene?.anchorPoint = .zero
        
        player.position = CGPoint(x: 0, y: 0)
        player.setScale(0.1)
        
        // Set up physics body for the player
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = false
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = 0x1 << 0
        player.physicsBody?.collisionBitMask = 0x1 << 1
        player.physicsBody?.contactTestBitMask = 0x1 << 1
        
        addChild(player)
        
        connectVirtualController()
        // end
    }

    
    //Joystick

    override func update(_ currentTime: TimeInterval) {
        if let thumbstick = virtualController?.controller?.extendedGamepad?.leftThumbstick {
            let playerPosx = CGFloat(thumbstick.xAxis.value)
            let playerPosy = CGFloat(thumbstick.yAxis.value)
            
            let movementSpeed: CGFloat = 3.0
            let newPosition = CGPoint(x: player.position.x + playerPosx * movementSpeed, y: player.position.y + playerPosy * movementSpeed)
            
            player.physicsBody?.velocity = CGVector(dx: playerPosx * movementSpeed * 60, dy: playerPosy * movementSpeed * 60)
            player.physicsBody?.allowsRotation = false
            
            if let body = player.physicsBody, !body.allContactedBodies().isEmpty {
                player.position = newPosition
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
        addChild(cameraNode)
    }
    
    func drawDungeon(rooms: [Room]) {
        
        
        
        
        for room in rooms {
            // try drawing a square
            for _ in 1...10 {
                let square1 = SKSpriteNode(imageNamed: "player")
                square1.position = room.position
                square1.setScale(0.1)
                square1.physicsBody = SKPhysicsBody(circleOfRadius: 10)
                addChild(square1)
            }
            
            let roomNode = SKSpriteNode(imageNamed: room.getRoomImage())
            roomNode.position = room.position
            roomNode.xScale = 1.1
            roomNode.yScale = 1.1
            
            // Set up the physics body based on the room image
            roomNode.physicsBody = SKPhysicsBody(texture: roomNode.texture!, size: roomNode.size)
            roomNode.physicsBody?.isDynamic = false
            
            // new
            roomNode.physicsBody?.usesPreciseCollisionDetection = true
            
            roomNode.physicsBody?.collisionBitMask = 0x1
            roomNode.physicsBody?.contactTestBitMask = 0x1 << 1
            roomNode.physicsBody?.categoryBitMask = 0x1 << 1

            addChild(roomNode)
        }
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
