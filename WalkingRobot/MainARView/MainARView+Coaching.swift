//
//  MainARView+Coaching.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import ARKit

extension MainARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        self.coachingOverlay.delegate = self
        self.coachingOverlay.session = self.session
        self.coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.coachingOverlay.goal = .horizontalPlane
        
        self.addSubview(coachingOverlay)
    }
}
