//
//  UIHelper.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 03/10/2021.
//

import Foundation
import RealityKit
import UIKit

struct UIHelper {
    static func randomColour() -> SimpleMaterial.BaseColor {
        let randomColour: UIColor = [.cyan, .blue, .brown, .darkGray, .green, .magenta, .systemPink, .orange, .systemMint].randomElement()!
        return SimpleMaterial.BaseColor(tint: randomColour.withAlphaComponent(0.5))
    }
}
