//
//  MainARView+Configuration.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import ARKit

extension MainARView: ARCoachingOverlayViewDelegate {
    func addConfiguration() {
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("configurations are not supported for this device sorry.")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = [.personSegmentationWithDepth]
        configuration.planeDetection = [.horizontal]
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            configuration.sceneReconstruction = .meshWithClassification
        }
        
        debugOptions = [.showSceneUnderstanding, .showPhysics]
        
        environment.sceneUnderstanding.options = [.physics, .occlusion]
//        debugOptions = [.showAnchorGeometry, .showAnchorOrigins, .showFeaturePoints, .showPhysics, .showSceneUnderstanding, .showAnchorGeometry]
        session.run(configuration, options: [.removeExistingAnchors])
    }
    
    func addCoaching() {
        self.coachingOverlay.delegate = self
        self.coachingOverlay.session = self.session
        self.coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }
}
