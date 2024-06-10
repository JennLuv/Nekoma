//
//  DungeonRoomViewModel.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 10/06/24.
//

import Foundation
import SpriteKit

class DungeonScene: SKScene {
    var idCounter = 1
    var cameraNode: SKCameraNode!
    var lastPanLocation: CGPoint?
    
    override func didMove(to view: SKView) {
        setupCamera()
        let rooms = generateLevel(roomCount: 5)
        print(rooms)
        drawDungeon(rooms: rooms)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
    }

    
    func drawDungeon(rooms: [Room]) {
            for room in rooms {
                let roomNode = SKSpriteNode(imageNamed: room.getRoomImage())
                roomNode.position = room.position
                roomNode.xScale = 0.7
                roomNode.yScale = 0.7
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

    func randomizeNextDirections(from: Direction, branch: Int ) -> [Direction] {
        var nextRoom: [Direction] = []
        
        var branches:[Direction] = [from]
        
        for _ in 0..<branch {
            var nextBranches = allDirection
            nextBranches = nextBranches.filter { !branches.contains($0!) }
            
            let nextBranch = (nextBranches.randomElement() ?? Direction(rawValue: "Up"))!
            branches.append(nextBranch)
            nextRoom.append(nextBranch)
        }
        
        return nextRoom
    }

    func generateLevel(roomCount: Int, catAppearance: Int? = nil) -> [Room] {
        print("Generate level invoked")
        // Generate First Room
        let nextDirection = allDirection.randomElement()!
        let firstRoom = Room(id: idCounter, from: 0, toDirection: [nextDirection!], position: CGPoint(x: 0, y: 0))
        idCounter += 1
        
        var rooms = [firstRoom]
        var currentRoom = firstRoom
        
        for _ in 2...roomCount {
            let nextDirections = currentRoom.toDirection
            // let's take one of the directions to make a room
            let nextDirection = nextDirections!.randomElement()
            // the next room is from the opposite
            let nextRoomFrom = getOppositeDirection(from: nextDirection!)
            
            let nextRoomTo = randomizeNextDirections(from: nextRoomFrom, branch: 1)
            
            
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
            
            
            // create next room
            let nextRoom = Room(id: idCounter, from: currentRoom.id, fromDirection: nextRoomFrom, toDirection: nextRoomTo, position: nextRoomPosition)
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
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = view else { return }
        
        let location = gestureRecognizer.location(in: view)
        
        if gestureRecognizer.state == .began {
            lastPanLocation = location
        } else if gestureRecognizer.state == .changed {
            if let lastLocation = lastPanLocation {
                let deltaX = location.x - lastLocation.x
                let deltaY = location.y - lastLocation.y
                cameraNode.position.x -= deltaX
                cameraNode.position.y += deltaY
                lastPanLocation = location
            }
        } else if gestureRecognizer.state == .ended {
            lastPanLocation = nil
        }
    }
}
