//
//  MessangeHandler.swift
//  multiTest
//
//  Created by André Bongartz on 29.08.25.
//

import Foundation
import RealityKit
import GroupActivities

extension AppModel {
    func handle(_ message: SharedActivityMessage) {
        print("modelEnitities[0].modelId: \(modelEnitities[0].modelId)")
        print("Received Message for modelId: \(message.modelId)")
        if let modelIndex = modelEnitities.firstIndex(where: { $0.modelId == message.modelId }) {
            let modelEnitity = modelEnitities[modelIndex]
            modelEnitity.enitity.position = SIMD3(x: message.x, y: message.y, z: message.z)
            modelEnitity.enitity.scale = SIMD3(x: message.scaleX, y: message.scaleY, z: message.scaleZ)
            print("Model \(modelEnitity.enitity.name) moved to position: \(modelEnitity.enitity.position)")
        }
    }

    func send(modelId: UInt64, position: SIMD3<Float>, scale: SIMD3<Float>) {
        if let messenger = groupSessionMessenger {
            print("send Message")
            Task {
                try? await messenger.send(SharedActivityMessage(
                    modelId: modelId,
                    x: position.x,
                    y: position.y,
                    z: position.z,
                    scaleX: scale.x,
                    scaleY: scale.y,
                    scaleZ: scale.z
                )
                )
            }
        }
    }
}
