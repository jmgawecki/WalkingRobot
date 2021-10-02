//
//  MainARView+Gestures.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 02/10/2021.
//

import SwiftUI

extension MainARView {
    func addGestureRecognisers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let tapLocation = sender?.location(in: self)
        guard let tapLocation = tapLocation else {
            return
        }
        if let robot = entity(at: tapLocation) {
            print(robot.name)
        }
    }
}
