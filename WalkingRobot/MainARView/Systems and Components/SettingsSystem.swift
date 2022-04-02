//
//  SettingsSystem.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 09/10/2021.
//

import RealityKit

struct SettingsComponent: RealityKit.Component {
    var robotSpeed: Float = 0.05 // 5 cm per second
}

class SettingsSystem: RealityKit.System {
    
    private static let query = EntityQuery(where: .has(SettingsComponent.self))
    
    required init(scene: Scene) {}
    
    
    func update(context: SceneUpdateContext) {}

}
