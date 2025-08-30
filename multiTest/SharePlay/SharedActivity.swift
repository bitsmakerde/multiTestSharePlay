//
//  SharedActivity.swift
//  USDPlacer
//
//  Created by André Bongartz on 26.08.25.
//

import Foundation
import GroupActivities
import SwiftUI

struct SharedActivity: GroupActivity, Transferable, Sendable {
    var metadata: GroupActivityMetadata = {
        var metadata = GroupActivityMetadata()
        metadata.title = "Guess Together"
        return metadata
    }()
}
