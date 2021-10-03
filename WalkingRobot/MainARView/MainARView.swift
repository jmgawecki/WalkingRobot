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
    var robotTranslationSubscribtion: Cancellable?
    var gestureRecogniser: EntityGestureRecognizer? {
        didSet {
            gestureRecogniser?.addTarget(self, action: #selector(handleRobotTranslation(_:)))
        }
    }
    
    // MARK: - Initialiser
    required init() {
        super.init(frame: .zero)
        robot = MegaRobot(anchorEntity: planeAnchor, arView: self, gameSettings: gameSettings)
        observeAnchorState()
        addConfiguration()
        addCoaching()
        addGestureRecognisers()
        session.delegate = self
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
            self.anchorEntitySubscribtion = self.scene.subscribe(
                to: SceneEvents.AnchoredStateChanged.self,
                on: robot) { [weak self] robotEvent in
                    guard let self = self else { return }
                    if robotEvent.isAnchored {
                        self.gameSettings.gameStatus = .positioning
                        robot.stage()
                        robot.walkAnimationController?.resume()
                        self.observeAnimationState()
                        self.gestureRecogniser = self.installGestures(.translation, for: robot).first
                        DispatchQueue.main.async {
                            self.anchorEntitySubscribtion?.cancel()
                            self.anchorEntitySubscribtion = nil
                        }
                    }
                }
            self.scene.anchors.append(robot)
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
