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
    
    // MARK: - Initialiser
    required init() {
        super.init(frame: .zero)
        robot = MegaRobot(anchorEntity: planeAnchor, arView: self, gameSettings: gameSettings)
        addAnchorAndObserve()
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
    
    func addAnchorAndObserve() {
        if let robot = robot {
            self.gameSettings.gameStatus = .planeSearching
            self.anchorEntitySubscribtion = self.scene.subscribe(
                to: SceneEvents.AnchoredStateChanged.self,
                on: planeAnchor) { anchored in
                    if anchored.isAnchored {
                        robot.robotMode()
                        robot.animationController?.resume()
                        robot.activateRobotDragging()
                        self.gameSettings.gameStatus = .positioning
                        DispatchQueue.main.async {
                            self.anchorEntitySubscribtion?.cancel()
                            self.anchorEntitySubscribtion = nil
                        }
                    }
                }
            self.scene.anchors.append(planeAnchor)
        } else {
            print("Fail to load")
        }
    }
}
