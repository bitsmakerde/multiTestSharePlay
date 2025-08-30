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
        if let modelIndex = modelEnitities.firstIndex(where: { $0.id == message.modelId }) {
            let modelEnitity = modelEnitities[modelIndex]
            modelEnitity.position = SIMD3(x: message.x, y: message.y, z: message.z)
            print("Model \(modelEnitity.name) moved to position: \(modelEnitity.position)")
        }
    }

    func send(modelId: UInt64, position: SIMD3<Float>) {
        if let messenger = groupSessionMessenger {
            print("send Message")
            Task {
                try? await messenger.send(SharedActivityMessage(
                    modelId: modelId,
                    x: position.x,
                    y: position.y,
                    z: position.z
                )
                )
            }
        }
    }
}
