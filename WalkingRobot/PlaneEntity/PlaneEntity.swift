//
//  PlaneEntity.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 03/10/2021.
//

import Foundation
import ARKit
import RealityKit

class PlaneEntity: Entity, HasAnchoring {
    var planeMesh: MeshResource
    var colourMaterial: SimpleMaterial
    var plane: ModelEntity
    
    init(with planeAnchor: ARPlaneAnchor) {
        planeMesh = MeshResource.generatePlane(
            width: planeAnchor.extent.x,
            depth: planeAnchor.extent.z
        )
        
        colourMaterial = SimpleMaterial()
        colourMaterial.color = UIHelper.randomColour()
        
        plane = ModelEntity(mesh: planeMesh, materials: [colourMaterial])
        plane.transform.matrix = planeAnchor.transform
        super.init()
        addChild(plane)
    }
    
    required init() { fatalError("init() has not been implemented") }
    
    
}
