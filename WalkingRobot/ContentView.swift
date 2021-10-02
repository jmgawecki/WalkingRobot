//
//  ContentView.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 30/09/2021.
//

import SwiftUI
import RealityKit
import Combine
import ARKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = MainARView()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
