//
//  Robot.swift.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 05/10/2021.
//

import Foundation
import RealityKit

extension MainARView {
    
    func loadRobotModel() {
        ModelEntity.loadAsync(named: "toy_robot")
            .sink { _ in
            } receiveValue: { robot in
                self.addRobot(robot: robot)
            }
            .store(in: &subscriptions)
        
    }
    
    func addRobot(robot: Entity) {
        let robot = robot
        robot.components[WalkingComponent.self] = WalkingComponent()
        robot.components[AnchoringComponent.self] = AnchoringComponent(
            AnchoringComponent.Target.plane(
                .horizontal,
                classification: .any,
                minimumBounds: [1,1]
            )
        )
        //        scene.addAnchor(robot)
    }
}
