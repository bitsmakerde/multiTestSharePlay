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
                    appModel.send(
                        modelId: event.entity.id,
                        position: event.entity.transform.translation,
                        scale: event.entity.scale
                    )
                }
                _ = content.subscribe(to: ManipulationEvents.DidUpdateTransform.self) { event in
                    appModel.send(
                        modelId: appModel.modelEnitities[0].modelId,
                        position: event.entity.transform.translation,
                        scale: event.entity.scale
                    )
                }
                
                _ = content.subscribe(to: ManipulationEvents.WillEnd.self) { event in
                    appModel.send(
                        modelId: appModel.modelEnitities[0].modelId,
                        position: event.entity.transform.translation,
                        scale: event.entity.scale
                    )
                }
                
#endif
                content.add(immersiveContentEntity)
                let sharedModel = SharedModel(modelId: 1, enitity: immersiveContentEntity)
                appModel.modelEnitities.append(sharedModel)
            } catch {
                print("Error loading entity: \(error)")
            }
        }
//        .gesture(TapGesture(count: 1).targetedToAnyEntity()
//            .onEnded { value in
//                value.entity.transform = Transform(scale: SIMD3<Float>(2.0, 2.0, 2.0))
//                appModel.send(modelId: appModel.modelEnitities[0].modelId, position: value.entity.position, scale: value.entity.scale)
//            }
//        )
        .gesture(DragGesture(minimumDistance: 0).targetedToAnyEntity()
            .onChanged { value in
                let currentPosition = value.entity.position
                print("currentPosition: \(currentPosition)")
                print("value.translation: \(value.translation.width), heigt: \(value.translation.height)")
                let newPosition = SIMD3<Float>(
                    currentPosition.x + Float(value.translation.width) * 0.01,
                    currentPosition.y - Float(value.translation.height) * 0.01,
                    currentPosition.z
                )
                value.entity.position = newPosition
                appModel.send(modelId: appModel.modelEnitities[0].modelId, position: newPosition, scale: value.entity.scale)
            })
    }
}

#Preview {
    ImmersiveView()
}
