//
//  ImmersiveView.swift
//  multiTest
//
//  Created by André Bongartz on 29.08.25.
//

import GroupActivities
import RealityKit
import SwiftUI

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    var body: some View {
        RealityView { content in
            do {
                let immersiveContentEntity = try await Entity(named: "toy_car")
                immersiveContentEntity.components.set(InputTargetComponent())
                immersiveContentEntity.generateCollisionShapes(recursive: true)
                
#if os(visionOS)
                immersiveContentEntity.position = SIMD3(x: 0, y: 0, z: -2)
                ManipulationComponent.configureEntity(immersiveContentEntity)
                var mc = ManipulationComponent()
                mc.releaseBehavior = .stay
                
                immersiveContentEntity.components.set(mc)
                
                // get manipulation events for moveing the entity
                _ = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                    print("update begin\(event.entity.transform.translation)")
                    print("\(event.entity.name)")
                    appModel.send(modelId: event.entity.id, position: event.entity.transform.translation)
                }
                _ = content.subscribe(to: ManipulationEvents.DidUpdateTransform.self) { event in
                    print("update DidUpdateTransform\(event.entity.transform.translation)")
                    appModel.send(modelId: event.entity.id, position: event.entity.transform.translation)
                }
                
                _ = content.subscribe(to: ManipulationEvents.WillEnd.self) { event in
                    print("update WillEnd\(event.entity.transform.translation)")
                    appModel.send(modelId: event.entity.id, position: event.entity.transform.translation)
                }
                
#endif
                content.add(immersiveContentEntity)
            } catch {
                print("Error loading entity: \(error)")
            }
        }.gesture(TapGesture(count: 1).targetedToAnyEntity()
            .onEnded({ value in
                print("tapped on entity: \(value.entity.name)")
                value.entity.transform = Transform(scale: SIMD3<Float>(2.0, 2.0, 2.0))
                appModel.send(modelId: value.entity.id, position: value.entity.position)
            })
        )
    }
}

#Preview {
    ImmersiveView()
}
