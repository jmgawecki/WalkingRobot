//
//  TurnSystem.swift.swift
//  WalkingRobot
//
//  Created by Jakub Gawecki on 09/10/2021.
//

import RealityKit

struct TurnComponent: RealityKit.Component {

    
}


class TurnSystem: RealityKit.System {
    
    private static let query = EntityQuery(where: .has(TurnComponent.self))
    
    static var dependencies: [SystemDependency] { [.before(WalkSystem.self)]}
    
    required init(scene: Scene) { }
    
    func update(context: SceneUpdateContext) {
        let turners = context.scene.performQuery(Self.query)
        
        turners.forEach { entity in
            guard
                let walk = entity.components[WalkComponent.self] as? WalkComponent,
                let turn = entity.components[TurnComponent.self] as? TurnComponent
            else { return }
            
            
            
            
            
            
            
            
            
            
        }
    }
    
}
