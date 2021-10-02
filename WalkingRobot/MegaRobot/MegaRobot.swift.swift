//
//  MegaRobot.swift.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import Foundation
import RealityKit
import Combine

class MegaRobot: Entity, HasCollision, HasAnchoring, HasPhysics {
    // MARK: - Declaration
    var robot: Entity?
    var subscriptions: Set<AnyCancellable> = []
    var animationController: AnimationPlaybackController?
    var arView: ARView
    var modeRobot: RobotMode = .initialising {
        didSet {
            print("Robot ended '\(oldValue)' mode")
            print("Robot entered '\(modeRobot)' mode")
        }
    }
    var gameSettings: Settings
    
    // MARK: - Initialiser
    required init(anchorEntity: AnchorEntity, arView: ARView, gameSettings: Settings) {
        self.gameSettings = gameSettings
        self.arView = arView
        super.init()
        addRobot(to: anchorEntity)
        addCollision()
        name = "Mega robot"
    }
    
    required init() { fatalError("init() has not been implemented") }
    
    func addRobot(to planeAnchor: AnchorEntity) {
        ModelEntity.loadAsync(named: "toy_robot")
            .sink { _ in
            } receiveValue: { robot in
                // Will generate collision boxes automatically
                robot.generateCollisionShapes(recursive: true)
                self.generateCollisionShapes(recursive: true)
                self.activateRobotDragging()
                // Entity should be added before the animation is started.
                planeAnchor.addChild(robot)
                if let walkingAnimation = robot.availableAnimations.first {
                    self.animationController = robot.playAnimation(walkingAnimation.repeat(duration: .infinity),
                                                                   transitionDuration: 1.25,
                                                                   blendLayerOffset: 0,
                                                                   separateAnimatedValue: false,
                                                                   startsPaused: false)
                    self.animationController?.pause()
                    robot.components[CollisionComponent.self] = CollisionComponent.init(shapes: [.generateBox(width: 0.3,
                                                                                                              height: 0.3,
                                                                                                              depth: 0.3)])
                    
                }
                self.robot = robot
            }
            .store(in: &subscriptions)
    }
    
    func activateRobotDragging() {
        guard robot != nil else {
            return
        }
        if let hasCollisions = robot as? HasCollision {
            arView.installGestures(.all, for: hasCollisions)
            arView.installGestures(.all, for: self)
        }
    }
    
    func addCollision() {
        components[CollisionComponent.self] = CollisionComponent.init(shapes: [.generateBox(width: 0.3,
                                                                                            height: 0.3,
                                                                                            depth: 0.3)])
    }
}
