//
//  WalkSystem.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 05/10/2021.
//

import Foundation
import RealityKit

class WalkSystem: RealityKit.System {
    
    private static let query = EntityQuery(where: .has(WalkComponent.self))
    
    // should always run before the MotionSystem, as it modifies it
    static var dependencies: [SystemDependency] { [.before(MotionSystem.self)]}
    
    required init(scene: Scene) { }
    
    func update(context: SceneUpdateContext) {
        let walkers = context.scene.performQuery(Self.query)
        
        for entity in walkers {
            guard var walker = entity.components[WalkComponent.self] as? WalkComponent,
                  var motion = entity.components[MotionComponent.self] as? MotionComponent else { continue }
            
            // set the default destination to 0
            var distanceFromDestination: Float = 0
            
            // check if walker component for this specific entity has any destination
            if let destination = walker.destination {
                // distract distance from it
                distanceFromDestination = entity.distance(from: destination)
            }
            
            // check if the distance still is. If its tiny, then lets choose another distance
            if distanceFromDestination < 0.01 {
                var newDestination = SIMD3<Float>.spawnPoint(from: SIMD3<Float>(0,0,0), radius: 0.7)
                
                newDestination.y = Float(0)
                
                // If there is any obstacle on the way to the destination, set that obstacle as the destination so it wont pass it, perhaps through the wall
                let obstacles = context.scene.raycast(
                    from: entity.position,
                    to: newDestination,
                    query: .nearest,
                    mask: .sceneUnderstanding,
                    relativeTo: nil
                )
                
                if let nearest = obstacles.first {
                    newDestination = nearest.position
                }
                
                walker.destination = newDestination
            }
            
            if let destination = walker.destination {
                // normalize returns vector pointing to the direction??
                var steer = normalize(destination - entity.position)
                // multiply steer by velocity??
                steer *= walker.wanderlust * 0.018
                
                // substract motion velocity??
                steer -= motion.velocity
                // Add that steer as a Force to motion component
                motion.forces.append(MotionComponent.Force(acceleration: steer, multiplier: 1.0, name: "walker"))
            }
                 
            // End
            entity.components[MotionComponent.self] = motion
            entity.components[WalkComponent.self] = walker
        }
    }
}
