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
        }
    }
}
