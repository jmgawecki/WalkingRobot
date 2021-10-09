//
//  MainARView+ARSessionDelegate.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 03/10/2021.
//

import Foundation
import ARKit
import RealityKit

extension MainARView: ARSessionDelegate {    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        switch frame.worldMappingStatus {
        case .notAvailable:
            break
        case .limited:
            break
        case .extending:
            break
        case .mapped:
            scene.addAnchor(plane)
            plane.addChild(ball)
            self.installGestures(.translation, for: ball as! HasCollision)
        @unknown default:
            break
        }
    }
}
