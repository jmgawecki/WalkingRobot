//
//  MainARView+ARSessionDelegate.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 03/10/2021.
//

import Foundation
import ARKit
import RealityKit

class PlaneEntity: Entity, HasAnchoring {
    
    init(with planeAnchor: ARPlaneAnchor) {
        let anchorMatrix = planeAnchor.transform
        let anchorExtent = planeAnchor.extent

        let planeMesh = MeshResource.generatePlane(width: anchorExtent.x, depth: anchorExtent.z)
        let metal = SimpleMaterial(color: .cyan, isMetallic: true)
        let entityPlane: Entity = ModelEntity(mesh: planeMesh, materials: [metal])
        entityPlane.transform.matrix = anchorMatrix
        super.init()
        addChild(entityPlane)
    }
    
    required init() { fatalError("init() has not been implemented") }
}

extension MainARView: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        let planeAnchors = anchors.map { $0 as! ARPlaneAnchor }
        for planeAnchor in planeAnchors {
            let planeEntity = PlaneEntity(with: planeAnchor)
            
            scene.anchors.append(planeEntity)
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("anchor updated")
        for anchor in anchors {
            if let _ = anchor as? ARPlaneAnchor {
                print("plane anchor detected")
            }
        }
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("session interruption ended")
    }
}
