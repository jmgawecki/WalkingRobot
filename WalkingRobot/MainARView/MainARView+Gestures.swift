//
//  MainARView+Gestures.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import SwiftUI
import RealityKit

extension MainARView {
    func addGestureRecognisers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let tapLocation = sender?.location(in: self)
        guard let tapLocation = tapLocation else {
            return
        }
        if let robot = entity(at: tapLocation) {
            print(robot.name)
        }
    }
    
    @objc func handleRobotTranslation(_ recogniser: UIGestureRecognizer) {
        guard let translationGesture = recogniser as? EntityTranslationGestureRecognizer else { return }
        
        switch translationGesture.state {
        case .began:
            robot?.walkAnimationController?.pause()
        case .ended:
            if robot?.currentStage != .initialising,
               robot?.currentStage != .wait {
                robot?.walkAnimationController?.resume()
            }
        case .possible:
            fallthrough
        case .changed:
            fallthrough
        case .cancelled:
            fallthrough
        case .failed:
            fallthrough
        @unknown default:
            break
        }
    }
}
