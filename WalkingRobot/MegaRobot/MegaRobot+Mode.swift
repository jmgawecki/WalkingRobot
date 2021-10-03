//
//  MegaRobot+Mode.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import ARKit
import RealityKit

enum RobotStage: CaseIterable {
    case initialising
    case walk
    case turnAround
    case wait
}

extension MegaRobot {
    /// Activates stage selection.
    func stage() {
        var stage: RobotStage = .initialising
        repeat {
            stage = RobotStage.allCases.randomElement()!
        } while stage == .initialising
        
        switch stage {
        case .initialising:
            fallthrough
            
        case .walk:
            walk()
            
        case .turnAround:
            turnAround()
            
        case .wait:
            wait { [weak self] in
                guard let self = self else { return }
                self.stage()
            }
        }
    }
    
    func walk() {
        guard let animationController = walkAnimationController else {
            return
        }
        animationController.resume()
        self.currentStage = .walk
        guard let robot = robot else {
            return
        }
        var walkTransform = robot.transform
        
        guard let translationAndTime = randomPath(from: walkTransform) else {
            return
        }
        let (translation , travelTime) = translationAndTime
        walkTransform.translation = translation
        
        guard let anchorEntity = robot.parent else {
            return
        }
        
        robot.move(to: walkTransform,
                   relativeTo: anchorEntity,
                   duration: travelTime,
                   timingFunction: .linear)
    }
    
    func turnAround() {
        guard let animationController = walkAnimationController else {
            return
        }
        animationController.resume()
        self.currentStage = .turnAround
        guard let robot = robot else {
            return
        }
        var turnAroundTransform = robot.transform
        turnAroundTransform.rotation = simd_quatf(angle: .pi * [-1.0,1.0].randomElement()!, axis: [0,1,0])
        let turnTime = Double.random(in: 3.0...6)
        
        guard let anchorEntity = robot.parent else {
            return
        }
        robot.move(to: turnAroundTransform,
                   relativeTo: anchorEntity,
                   duration: turnTime,
                   timingFunction: .linear)
    }
    
    func wait(completion: @escaping () -> Void) {
        self.currentStage = .wait
        guard let animationController = walkAnimationController else {
            completion()
            return
        }
        animationController.pause()
        let waitTime = Double.random(in: 2...3.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
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
