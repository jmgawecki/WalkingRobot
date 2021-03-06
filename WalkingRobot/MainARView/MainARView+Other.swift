//
//  MainARView+Other.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import ARKit

enum GameStatus {
    case initCoaching
    case planeSearching
    case positioning
    case playing
    case finished
}

class Settings {
    var robotSpeed: Float = 0.03 // m/s
    
    var gameStatus: GameStatus = .initCoaching {
        didSet {
            print("status was: \(oldValue)")
            print("status is: \(gameStatus)")
        }
    }
}

extension MainARView {
        // Counts the distance between the camera and the robot, use for running away if too close
        func distanceToCamera() -> Float {
            guard let robot = robot else {
                return 100
            }
            return distance(cameraTransform.translation, robot.position(relativeTo: nil))
        }
}
