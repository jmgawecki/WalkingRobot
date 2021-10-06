//
//  WalkComponent.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 05/10/2021.
//

import Foundation
import RealityKit

struct WalkComponent: RealityKit.Component {
    var destination: SIMD3<Float>?
    
    let wanderlust: Float = 0.1
}
