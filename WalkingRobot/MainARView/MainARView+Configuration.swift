//
//  MainARView+Configuration.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import ARKit

extension MainARView {
    func addConfiguration() {
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("configurations are not supported for this device sorry.")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = [.personSegmentationWithDepth]
        configuration.planeDetection = [.horizontal]
        
        session.run(configuration, options: [.removeExistingAnchors])
    }
}
