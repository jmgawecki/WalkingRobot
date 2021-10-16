//
//  RobotARView.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import SwiftUI
import ARKit
import Combine
import RealityKit

class MainARView: ARView {
    // MARK: - Game Status
    let coachingOverlay = ARCoachingOverlayView()
    
    // MARK: - Declaration
    var robot: Entity?
    var subscriptions: Set<AnyCancellable> = []
    var robotAnchoringSubscription: Cancellable?
    
    let plane = AnchorEntity(
        plane: .horizontal,
        classification: .floor,
        minimumBounds: [2,2]
    )
    
    
    lazy var ball: Entity = {
        let ball = MeshResource.generateSphere(radius: 0.3)
        let entity = ModelEntity(mesh: ball)
        entity.physicsBody = .init()
        entity.generateCollisionShapes(recursive: true)
        entity.transform.translation = SIMD3<Float>.init(x: 0, y: 2, z: 0)
        return entity
    }()
    
    // MARK: - Initialiser
    required init() {
        super.init(frame: .zero)
        addConfiguration()
        addCoaching()
        ModelEntity.loadAsync(named: "toy_robot")
            .sink { _ in
                print("completed")
            } receiveValue: { [weak self] robot in
                guard let self = self else { return }
                self.plane.addChild(robot)
                self.robot = robot
                self.robot!.components[WalkComponent.self] = WalkComponent()
                self.robot!.components[TurnComponent.self] = TurnComponent()
                self.robot!.components[SettingsComponent.self] = SettingsComponent.init()
                if let animation = self.robot!.availableAnimations.first {
                    robot.playAnimation(
                        animation.repeat(duration: .infinity),
                        transitionDuration: 1.25,
                        blendLayerOffset: 0,
                        separateAnimatedValue: false,
                        startsPaused: false
                    )
                }
            }
            .store(in: &subscriptions)
        session.delegate = self
    }
    
    @MainActor @objc required dynamic init(frame frameRect: CGRect) { fatalError("init(frame:) has not been implemented") }
    
    @MainActor @objc required dynamic init?(coder decoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}
