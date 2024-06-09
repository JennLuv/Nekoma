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
    var randomFourthRoomImage: String = ""
    var gridSize: CGSize = CGSize(width: 905, height: 905)
//    var gridSize: CGSize = CGSize(width: 259.2, height: 259.2)
    
    override func didMove(to view: SKView) {
        setupCamera()
        randomizeRoomSelection()
        
        let firstRoomPosition = CGPoint(x: 0, y: 0)
        let secondRoomPosition = calculateSecondRoomPosition(firstRoomPosition)
        let thirdRoomPosition = calculateThirdRoomPosition(secondRoomPosition)
        let fourthRoomPosition = calculateFourthRoomPosition(thirdRoomPosition)
        
        let rooms = [
            DungeonRoom(imageName: randomFirstRoomImage, position: firstRoomPosition),
            DungeonRoom(imageName: randomSecondRoomImage, position: secondRoomPosition),
            DungeonRoom(imageName: randomThirdRoomImage, position: thirdRoomPosition),
            DungeonRoom(imageName: randomFourthRoomImage, position: fourthRoomPosition)
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
            roomNode.xScale = 0.7
            roomNode.yScale = 0.7
            addChild(roomNode)
        }
    }
    
    func randomizeRoomSelection() {
        randomFirstRoomImage = ["Type1Right", "Type1Left", "Type1Up", "Type1Down"].randomElement() ?? "Type1Right"
        
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
        
        if randomSecondRoomImage.contains("RightUp") && randomThirdRoomImage.contains("RightDown") {
            randomFourthRoomImage = "Type1Left"
        } else if randomSecondRoomImage.contains("RightUp") && randomThirdRoomImage.contains("LeftDown") {
            randomFourthRoomImage = "Type1Right"
        } else if randomSecondRoomImage.contains("LeftUp") && randomThirdRoomImage.contains("RightDown") {
            randomFourthRoomImage = "Type1Left"
        } else if randomSecondRoomImage.contains("LeftUp") && randomThirdRoomImage.contains("LeftDown") {
            randomFourthRoomImage = "Type1Right"
        } else if randomSecondRoomImage.contains("RightUp") && randomThirdRoomImage.contains("LeftUp") {
            randomFourthRoomImage = "Type1Down"
        } else if randomSecondRoomImage.contains("RightUp") && randomThirdRoomImage.contains("LeftDown") {
            randomFourthRoomImage = "Type1Up"
        } else if randomSecondRoomImage.contains("LeftUp") && randomThirdRoomImage.contains("RightUp") {
            randomFourthRoomImage = "Type1Down"
        } else if randomSecondRoomImage.contains("LeftUp") && randomThirdRoomImage.contains("RightUp") {
            randomFourthRoomImage = "Type1Up"
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
    
    func calculateFourthRoomPosition(_ thirdRoomPosition: CGPoint) -> CGPoint {
        var fourthRoomPosition = thirdRoomPosition
        
        if randomFourthRoomImage.contains("Right") {
            fourthRoomPosition.x += gridSize.width
        } else if randomFourthRoomImage.contains("Left") {
            fourthRoomPosition.x -= gridSize.width
        } else if randomFourthRoomImage.contains("Up") {
            fourthRoomPosition.y -= gridSize.height
        } else if randomFourthRoomImage.contains("Down") {
            fourthRoomPosition.y += gridSize.height
        }
        
        return fourthRoomPosition
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
