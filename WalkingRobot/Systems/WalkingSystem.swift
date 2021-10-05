//
//  MotionSystem.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 05/10/2021.
//

import RealityKit
import Foundation

class WalkingSystem: RealityKit.System {
    
    required init(scene: Scene) { }
    
    private static let query = EntityQuery(where: .has(WalkingComponent.self))
    
    func update(context: SceneUpdateContext) {
        
        context.scene.performQuery(Self.query).forEach { entity in
            
            guard let _: WalkingComponent = entity.components[WalkingComponent.self]
            else { return }
            
            var newTransform = entity.transform
            
            let (newTranslation, travelTime) = randomPath(from: newTransform)
            
            newTransform.translation = newTranslation
            
            entity.move(
                to: newTransform,
                relativeTo: nil,
                duration: travelTime
            )
            
            entity.look(
                at: newTransform.translation,
                from: newTransform.translation - newTranslation,
                relativeTo: nil
            )
        }
    }
    
    
//    func walk() {
//        var walkTransform = robot.transform
//
//        let vectorTest = SIMD2<Float>.init(x: Float.random(in: 0.1...0.5), y: Float.random(in: 0.1...0.5))
//        let test = SIMD3<Float>.init(vectorTest, robot.transform.rotation.angle)
//
//        guard let translationAndTime = randomPath(from: walkTransform) else {
//            return
//        }
//        let (translation , travelTime) = translationAndTime
//        walkTransform.translation = translation
//
//        guard let anchorEntity = robot.parent else {
//            return
//        }
//
//        robot.move(to: walkTransform,
//                   relativeTo: anchorEntity,
//                   duration: travelTime,
//                   timingFunction: .linear)
//    }
  
    func randomPath(from currentTransform: Transform) -> (SIMD3<Float>, TimeInterval) {
        // Get the robot's current transform and translation
        let robotTranslation = currentTransform.translation
        
        // Generate random distances for a model to cross, relative to origin
        // User random relatively to the anchor entity's origin so that it wont go outside the box
        let randomXTranslation = Float.random(in: 0.2...0.5) * [-1.0,1.0].randomElement()!
        let randomZTranslation = Float.random(in: 0.1...0.4) * [-1.0,1.0].randomElement()!
        
        // Create a translation relative to the current transform
        // Use realative to let him walk as far long as he wants to
        let relativeXTranslation = robotTranslation.x + randomXTranslation
        let relativeZTranslation = robotTranslation.z + randomZTranslation
        
        // Find a path
        var path = (randomXTranslation * randomXTranslation + randomZTranslation * randomZTranslation).squareRoot()
        
        // Path only positive
        if path < 0 { path = -path }
        
        // Calculate the time of walking based on the distance and default speed
        let timeOfWalking: Float = path / Settings().robotSpeed
        
        // Based on old trasnlation calculate the new one
        let newTranslation: SIMD3<Float> = [randomXTranslation,
                                            Float(0),
                                            randomZTranslation]
        
        return (newTranslation, TimeInterval(timeOfWalking))
    }
}
