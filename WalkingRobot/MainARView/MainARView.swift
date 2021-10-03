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
    var gameSettings = Settings()
    
    
    // MARK: - Declaration
    let planeAnchor = AnchorEntity(
        plane: .horizontal,
        classification: .any,
        minimumBounds: [0.5,0.5]
    )
    var robot: MegaRobot?
    var anchorEntitySubscribtion: Cancellable?
    var robotAnimationSubscribtion: Cancellable?
    
    // MARK: - Initialiser
    required init() {
        super.init(frame: .zero)
        robot = MegaRobot(anchorEntity: planeAnchor, arView: self, gameSettings: gameSettings)
        observeAnchorState()
        addConfiguration()
        addCoaching()
        addGestureRecognisers()
    }
    
    @MainActor @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @MainActor @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func observeAnchorState() {
        if let robot = robot {
            self.gameSettings.gameStatus = .planeSearching
            // 1. Subscribe to changes
            self.anchorEntitySubscribtion = self.scene.subscribe(
                to: SceneEvents.AnchoredStateChanged.self,
                on: planeAnchor) { anchored in
                    // 3. if the change is the desired one, perform extra setup
                    if anchored.isAnchored {
                        robot.stage()
                        robot.walkAnimationController?.resume()
                        robot.activateRobotDragging()
//                        robot.components[PhysicsBodyComponent.self] = PhysicsBodyComponent.init()
                        self.observeAnimationState()
                        self.gameSettings.gameStatus = .positioning
                        DispatchQueue.main.async {
                            // 4. Remove subscriber if further observations are not needed
                            self.anchorEntitySubscribtion?.cancel()
                            self.anchorEntitySubscribtion = nil
                        }
                    }
                }
            // 2. add planeAnchor to the scene
            self.scene.anchors.append(planeAnchor)
        } else {
            print("Fail to load")
        }
    }
    
    func observeAnimationState() {
        if let robot = robot {
            self.robotAnimationSubscribtion = self.scene.subscribe(
                to: AnimationEvents.PlaybackCompleted.self,
                on: robot.robot, { _ in
                    robot.stage()
                })
        }
    }
}
