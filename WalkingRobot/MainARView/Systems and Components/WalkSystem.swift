//
//  WalkSystem.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 05/10/2021.
//

import Foundation
import RealityKit

struct WalkComponent: RealityKit.Component {
    var destination: SIMD3<Float>?
    var velocity: Float = 0.05
}

class WalkSystem: RealityKit.System {
    
    private static let query = EntityQuery(where: .has(WalkComponent.self))
    
    // should always run before the MotionSystem, as it modifies it
    static var dependencies: [SystemDependency] { [.before(MotionSystem.self)]}
    
    required init(scene: Scene) { }
    
    func update(context: SceneUpdateContext) {
        let walkers = context.scene.performQuery(Self.query)
        
        walkers.forEach({ entity in
            guard
                var walker = entity.components[WalkComponent.self] as? WalkComponent,
                let _ = entity.components[MotionComponent.self] as? MotionComponent,
                let settings = entity.components[SettingsComponent.self] as? SettingsComponent
            else { return }
            
            defer {
                entity.components[WalkComponent.self] = walker
            }
            
            // set the default destination to 0
            var distanceFromDestination: Float = 0

            // check if walker component for this specific entity has any destination
            if let destination = walker.destination {
                // distract distance from it
                distanceFromDestination = entity.distance(from: destination)
            }

            // check if the distance still is. If its tiny, then lets choose another distance
            if distanceFromDestination < 0.02 {
                var fixedDestination = SIMD3<Float>.spawnPoint(from: entity.transform.translation, radius: 0.7)
                fixedDestination.y = Float(0)

                // If there is any obstacle on the way to the destination, set that obstacle as the destination so it wont pass it, perhaps through the wall
                let obstacles = context.scene.raycast(
                    from: entity.position,
                    to: fixedDestination,
                    query: .nearest,
                    mask: .sceneUnderstanding,
                    relativeTo: nil
                )

                if let nearest = obstacles.first {
                    fixedDestination = nearest.position
                    fixedDestination.y = Float(0)
                }

                walker.destination = fixedDestination
                
                var newTransform = entity.transform
                newTransform.translation = walker.destination!
                
                let travelTime = TimeInterval(entity.distance(from: walker.destination!) / settings.robotSpeed)
                
                entity.move(
                    to: newTransform,
                    relativeTo: entity.parent,
                    duration: travelTime,
                    timingFunction: .linear
                )
            }
        })
    }
}
