//
//  SharedActivityMessage.swift
//  USDPlacer
//
//  Created by André Bongartz on 26.08.25.
//

import Foundation
import RealityKit

struct SharedActivityMessage: Codable {
    let modelId: UInt64
    let x: Float
    let y: Float
    let z: Float
    let scaleX: Float
    let scaleY: Float
    let scaleZ: Float
}

struct SharedModel {
    let modelId: UInt64
    let enitity: Entity
}
