//
//  MegaRobot+Mode.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import ARKit
import RealityKit

enum RobotMode: CaseIterable {
    case initialising
    case walk
    case turnAround
    case wait
}

extension MegaRobot {
    func robotMode() {
        let mode = RobotMode.allCases.randomElement()!
        switch mode {
        case .initialising:
            fallthrough
        case .walk:
            walk { [weak self] in
                guard let self = self else { return }
                self.robotMode()
            }
        case .turnAround:
            turnAround { [weak self] angle in
                guard let self = self else { return }
                self.robotMode()
            }
        case .wait:
            wait { [weak self] in
                guard let self = self else { return }
                self.robotMode()
            }
        }
    }
    
    func walk(completion: @escaping () -> Void) {
        self.modeRobot = .walk
        guard let robot = robot else {
            completion()
            return
        }
        let currentTransform = robot.transform
        
        // If something went wrong, ground the robot
        if currentTransform.translation.y != 0 {
            robot.move(to: currentTransform, relativeTo: nil)
        }
        
        guard let path = randomPath(from: currentTransform) else {
            completion()
            return
        }
        let (newTranslation , travelTime) = path
        
        //        let scale: SIMD3<Float> = SIMD3<Float>.init(x: 1, y: 1, z: 1)
        //        let rotation: simd_quatf = simd_quaternion(0,0,0,1)
        
        let newTransform = Transform(scale: currentTransform.scale,
                                     rotation: currentTransform.rotation,
                                     translation: newTranslation)
        guard let anchorEntity = robot.parent else {
            completion()
            return
        }
        robot.move(to: newTransform, relativeTo: anchorEntity, duration: travelTime)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + travelTime + 0.2) {
            completion()
        }
    }
    
    func turnAround(completion: @escaping (simd_quatf?) -> Void ) {
        self.modeRobot = .turnAround
        guard let robot = robot else {
            completion(nil)
            return
        }
        
        //        let angle: simd_quatf = simd_quaternion(0.75,0,0,1) // around 90 degrees laying down facing floor
        let randomMutation = Float.random(in: 0...1)
        let randomAngle = randomMutation * Float([-1.0,1.0].randomElement()!)
        let angle: simd_quatf = simd_quaternion(0,randomAngle,0,randomAngle) // 90 deegres to the right, last number should be the same
        
        let newTransform = Transform(scale: robot.transform.scale,
                                     rotation: angle,
                                     translation: robot.transform.translation)
        guard let anchorEntity = robot.parent else {
            completion(nil)
            return
        }
        let turnTime = Double.random(in: 3.0...6)
        robot.move(to: newTransform, relativeTo: anchorEntity, duration: turnTime)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + turnTime + 0.2) {
            completion(angle)
        }
    }
    
    func wait(completion: @escaping () -> Void) {
        self.modeRobot = .wait
        guard let animationController = animationController else {
            completion()
            return
        }
        animationController.pause()
        let waitTime = Double.random(in: 2...3.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime + 0.2) {
            animationController.resume()
            completion()
        }
    }
    
    func randomPath(from currentTransform: Transform) -> (SIMD3<Float>, TimeInterval)? {
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
        let timeOfWalking: Float = path / gameSettings.robotSpeed
        
        // Based on old trasnlation calculate the new one
        let newTranslation: SIMD3<Float> = [randomXTranslation,
                                            Float(0),
                                            randomZTranslation]
        
        return (newTranslation, TimeInterval(timeOfWalking))
    }
}
