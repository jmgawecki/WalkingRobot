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
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        // check if found anchors are Plane Anchors
//        let planeAnchors = anchors.map { $0 as! ARPlaneAnchor }
//        for planeAnchor in planeAnchors {
//            let planeEntity = PlaneEntity(with: planeAnchor)
//            scene.anchors.append(planeEntity)
//        }
    }
//
//    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
////        // Filter to ARPlaneAnchors only
////        let planeAnchors = anchors.map { $0 as! ARPlaneAnchor }
////
////        // Take all IDs of already attached ARPlaneAnchors
////        let scenePlaneAnchorsID = scene.anchors.map { $0.anchorIdentifier }
////
////        // Iterate through each updated ARPlaneAnchor
////        for planeAnchor in planeAnchors {
////            // Take id of updated anchor
////            let id = planeAnchor.identifier
////
////            // Look for matching id, if matches, update the transform
////            if scenePlaneAnchorsID.contains(id) {
////                print("found!")
////                let entityToUpdate = (scene.anchors.filter { $0.anchorIdentifier == id }).first
////                if let a = entityToUpdate as? PlaneEntity {
////                    print("plane entity")
////                }
////                if let b = entityToUpdate as? ARPlaneAnchor {
////                    print("just plane anchor")
////                }
////                if let c = entityToUpdate as? ModelEntity {
////                    print("model entity")
////                }
////            }
////        }
//    }
    
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
        @unknown default:
            break
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("session interruption ended")
    }
}
