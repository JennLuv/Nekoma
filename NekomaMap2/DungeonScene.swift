//
//  DungeonScene.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 09/06/24.
//

import SpriteKit

class DungeonScene: SKScene {
    
    var cameraNode: SKCameraNode!
    var lastPanLocation: CGPoint?
    var randomFirstRoomImage: String = ""
    var randomSecondRoomImage: String = ""
    var randomThirdRoomImage: String = ""
//    var gridSize: CGSize = CGSize(width: 905, height: 905)
    var gridSize: CGSize = CGSize(width: 259.2, height: 259.2)
    
    override func didMove(to view: SKView) {
        setupCamera()
        randomizeRoomSelection()
        
        let firstRoomPosition = CGPoint(x: 0, y: 0)
        let secondRoomPosition = calculateSecondRoomPosition(firstRoomPosition)
        let thirdRoomPosition = calculateThirdRoomPosition(secondRoomPosition)
        
        let rooms = [
            DungeonRoom(imageName: randomFirstRoomImage, position: firstRoomPosition),
            DungeonRoom(imageName: randomSecondRoomImage, position: secondRoomPosition),
            DungeonRoom(imageName: randomThirdRoomImage, position: thirdRoomPosition)
        ]
        
        drawDungeon(rooms: rooms)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
    }
    
    func drawDungeon(rooms: [DungeonRoom]) {
        for room in rooms {
            let roomNode = SKSpriteNode(imageNamed: room.imageName)
            roomNode.position = room.position
            roomNode.xScale = 0.2
            roomNode.yScale = 0.2
            addChild(roomNode)
        }
    }
    
    func randomizeRoomSelection() {
        // Generate random images for the first and second rooms
        randomFirstRoomImage = ["Type1Right", "Type1Left", "Type1Up", "Type1Down"].randomElement() ?? "Type1Right"
        
        // For the second room, ensure it complements the first room's image
        if randomFirstRoomImage.contains("Right") {
            randomSecondRoomImage = ["Type2LeftDown", "Type2LeftUp"].randomElement() ?? "Type2LeftDown"
        } else if randomFirstRoomImage.contains("Left") {
            randomSecondRoomImage = ["Type2RightDown", "Type2RightUp"].randomElement() ?? "Type2RightDown"
        } else if randomFirstRoomImage.contains("Up") {
            randomSecondRoomImage = ["Type2LeftDown", "Type2RightDown"].randomElement() ?? "Type2LeftDown"
        } else if randomFirstRoomImage.contains("Down") {
            randomSecondRoomImage = ["Type2LeftUp", "Type2RightUp"].randomElement() ?? "Type2LeftUp"
        }
        
        if (randomFirstRoomImage.contains("Left") || randomFirstRoomImage.contains("Right")) && randomSecondRoomImage.contains("Down") {
            randomThirdRoomImage = ["Type2RightUp", "Type2LeftUp"].randomElement() ?? "Type2RightUp"
        } else if (randomFirstRoomImage.contains("Left") || randomFirstRoomImage.contains("Right")) && randomSecondRoomImage.contains("Up") {
            randomThirdRoomImage = ["Type2RightDown", "Type2LeftDown"].randomElement() ?? "Type2RightDown"
        } else if (randomFirstRoomImage.contains("Up") || randomFirstRoomImage.contains("Down")) && randomSecondRoomImage.contains("Left") {
            randomThirdRoomImage = ["Type2RightUp", "Type2RightDown"].randomElement() ?? "Type2RightUp"
        } else if (randomFirstRoomImage.contains("Up") || randomFirstRoomImage.contains("Down")) && randomSecondRoomImage.contains("Right") {
            randomThirdRoomImage = ["Type2LeftDown", "Type2LeftUp"].randomElement() ?? "Type2LeftDown"
        }
        
    }
    
    func calculateSecondRoomPosition(_ firstRoomPosition: CGPoint) -> CGPoint {
        var secondRoomPosition = firstRoomPosition
        
        if randomFirstRoomImage.contains("Right") {
            secondRoomPosition.x += gridSize.width
        } else if randomFirstRoomImage.contains("Left") {
            secondRoomPosition.x -= gridSize.width
        } else if randomFirstRoomImage.contains("Up") {
            secondRoomPosition.y += gridSize.height
        } else if randomFirstRoomImage.contains("Down") {
            secondRoomPosition.y -= gridSize.height
        }
        
        return secondRoomPosition
    }
    
    func calculateThirdRoomPosition(_ secondRoomPosition: CGPoint) -> CGPoint {
        var thirdRoomPosition = secondRoomPosition
        
        if (randomFirstRoomImage.contains("Up") || randomFirstRoomImage.contains("Down")) && randomSecondRoomImage.contains("Left") {
            thirdRoomPosition.x -= gridSize.width
        } else if (randomFirstRoomImage.contains("Up") || randomFirstRoomImage.contains("Down")) && randomSecondRoomImage.contains("Right") {
            thirdRoomPosition.x += gridSize.width
        } else if (randomFirstRoomImage.contains("Left") || randomFirstRoomImage.contains("Right")) && randomSecondRoomImage.contains("Up") {
            thirdRoomPosition.y += gridSize.height
        } else if (randomFirstRoomImage.contains("Left") || randomFirstRoomImage.contains("Right")) && randomSecondRoomImage.contains("Down") {
            thirdRoomPosition.y -= gridSize.height
        }
        
        return thirdRoomPosition
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
