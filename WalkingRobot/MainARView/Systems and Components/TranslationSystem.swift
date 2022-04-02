//
//  TranslationSystem.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 09/10/2021.
//

import RealityKit

struct TranslationComponent: RealityKit.Component {
    var isTurning = false
}


class TranslationSysytem: RealityKit.System {
    
    private static let query = EntityQuery(where: .has(TranslationComponent.self))
    
    static var dependencies: [SystemDependency] { [.before(TurnSystem.self), .before(WalkSystem.self)] }
    
    required init(scene: Scene) { }
    
    func update(context: SceneUpdateContext) {
        let translationable = context.scene.performQuery(Self.query)
        
        translationable.forEach { entity in
            guard
                let translation = entity.components[TranslationComponent.self] as? TranslationComponent,
                let turn = entity.components[TurnComponent.self] as? TurnComponent,
                let walk = entity.components[WalkComponent.self] as? WalkComponent
            else { return }
            
            defer {
                entity.components[TranslationComponent.self] = translation
                entity.components[TurnComponent.self] = turn
                entity.components[WalkComponent.self] = walk
            }
            
            var distanceFromDestination: Float = 0
            
            if let destination = walk.destination {
                distanceFromDestination = entity.distance(from: destination)
            }
            
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
                
//                entity.look(
//                    at: newTransform.translation,
//                    from: entity.transform.translation,
//                    relativeTo: entity.parent
//                )
                
                entity.move(
                    to: newTransform,
                    relativeTo: entity.parent,
                    duration: travelTime,
                    timingFunction: .linear
                )
            }
        }
    }
}
