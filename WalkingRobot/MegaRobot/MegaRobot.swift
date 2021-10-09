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
    var walkAnimationController: AnimationPlaybackController?
    var currentStage: RobotStage = .initialising {
        didSet {
            print("Robot ended '\(oldValue)' mode")
            print("Robot entered '\(currentStage)' mode")
        }
    }
    var gameSettings: Settings
    var translationGesture: EntityGestureRecognizer?
    
    // MARK: - Initialiser
    required init(gameSettings: Settings) {
        self.gameSettings = gameSettings
        super.init()
        addRobot()
        name = "Mega robot"
        addAnchoring()
    }

    required init() { fatalError("init() has not been implemented") }
    
    func addRobot() {
        ModelEntity.loadAsync(named: "toy_robot")
            .sink { _ in
            } receiveValue: { [weak self] robot in
                guard let self = self else { return }
                // Entity should be added before the animation is started.
                self.robot = robot
                
                self.addChild(robot)
                
                // Will generate collision boxes automatically also for children
                self.generateCollisionShapes(recursive: true)
                
                if let walkingAnimation = robot.availableAnimations.first {
                    self.walkAnimationController = robot.playAnimation(
                        walkingAnimation.repeat(duration: .infinity),
                        transitionDuration: 1.25,
                        blendLayerOffset: 0,
                        separateAnimatedValue: false,
                        startsPaused: false
                    )
                    
                    self.walkAnimationController?.pause()
                }
                self.robot = robot
            }
            .store(in: &subscriptions)
    }
    
    func addAnchoring() {
        let anchorPlane = AnchoringComponent.Target.plane(
            .horizontal,
            classification: .floor,
            minimumBounds: SIMD2<Float>.init(x: 1, y: 1)
        )
        
        let anchorComponent = AnchoringComponent(anchorPlane)
        self.anchoring = anchorComponent
    }
}
