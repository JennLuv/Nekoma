//
//  JoyStick.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 10/06/24.
//

import Foundation
import SpriteKit
import GameController

class JoyStick: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    var virtualController: GCVirtualController?
    var playerPosx: CGFloat = 0
    var playerPosy: CGFloat = 0
    
    override func didMove(to view: SKView) {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: 600, height: 800)
        
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.zPosition = 10
        player.setScale(0.4)
        addChild(player)
        
        connectVirtualController()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
            if let thumbstick = virtualController?.controller?.extendedGamepad?.leftThumbstick {
                let playerPosx = CGFloat(thumbstick.xAxis.value)
                let playerPosy = CGFloat(thumbstick.yAxis.value)
                
                // Adjust the movement speed by multiplying with a factor
                let movementSpeed: CGFloat = 5.0
                player.position.x += playerPosx * movementSpeed
                player.position.y += playerPosy * movementSpeed
            }
        }
    
    func connectVirtualController() {
        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [GCInputLeftThumbstick, GCInputButtonA, GCInputButtonB]
        
        let controller = GCVirtualController(configuration: controllerConfig)
        controller.connect()
        virtualController = controller
    }
}
