import RealityKit

struct MotionComponent: RealityKit.Component { }

class MotionSystem: RealityKit.System {
    
    private static let query = EntityQuery(where: .has(MotionComponent.self))
    
    required init(scene: RealityKit.Scene) { }
    
    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
////            let fixedDelta: Float = Float(context.deltaTime)
//
//            guard let _ = entity.components[MotionComponent.self] as? MotionComponent,
//                  let walker = entity.components[WalkComponent.self] as? WalkComponent
//            else { return }
//            
//            var distanceFromDestination = Float(0)
//            
//            if let destination = walker.destination {
//                distanceFromDestination = entity.distance(from: destination)
//            }
//            
//            if distanceFromDestination < 0.02 {
//                
//            }
//
//            var newTransform = entity.transform
//
//            let s = (walker.destination! - entity.transform.translation) * 0.03 * fixedDelta
//
//            newTransform.translation = s
//            newTransform.translation.y = Float(0)
//
//            entity.move(to: newTransform, relativeTo: nil)
        }
    }
}


//            entity.look(
//                at: walker.destination!,
//                from: newTransform.translation,
//                relativeTo: nil
//            )
