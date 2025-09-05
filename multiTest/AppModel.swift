//
//  AppModel.swift
//  USDPlacer
//
//  Created by Bongartz, Andre (N/FI-N2) on 05.08.25.
//

import Combine
import GroupActivities
import RealityKit
import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
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
    func startShareSession() {
        Task {
            do {
                let activity = SharedActivity()
                _ = try await activity.activate()
                // The session will be automatically detected by our listener
            } catch {
                print("Failed to start SharePlay: \(error)")
            }
        }
    }

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
