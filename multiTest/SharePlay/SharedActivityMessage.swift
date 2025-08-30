//
//  SharedActivityMessage.swift
//  USDPlacer
//
//  Created by André Bongartz on 26.08.25.
//

import Foundation

struct SharedActivityMessage: Codable {
    let modelId: UInt64
    let x: Float
    let y: Float
    let z: Float
}
