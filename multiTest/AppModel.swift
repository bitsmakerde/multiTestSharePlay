//
//  AppModel.swift
//  USDPlacer
//
//  Created by Bongartz, Andre (N/FI-N2) on 05.08.25.
//

import SwiftUI
internal import Combine
import GroupActivities
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
#if os(visionOS)
    var content: RealityViewContent?
#else
    var content: RealityViewCameraContent?
#endif
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }

    var immersiveSpaceState = ImmersiveSpaceState.closed
    var modelName: String?
    var modelURL: URL?
    var isLocked: Bool = false
    var groupSession: GroupSession<SharedActivity>?
    var groupSessionMessenger: GroupSessionMessenger?
    var modelEnitities: [ModelEntity] = []
}

/// Monitor for new Guess Together group activity sessions.
extension AppModel {
    @Sendable
    func observeGroupSessions() async {
        for await session in SharedActivity.sessions() {
#if os(visionOS)
            guard let systemCoordinator = await session.systemCoordinator else { continue }
            systemCoordinator.configuration.supportsGroupImmersiveSpace = true
#endif
            groupSession = session
            groupSessionMessenger = GroupSessionMessenger(session: session)

            if let messenger = groupSessionMessenger {
                Task {
                    for await (message, _) in messenger.messages(of: SharedActivityMessage.self) {
                        handle(message)
                    }
                }
            }

            // Join SharePlay
            session.join()
        }
    }
}
