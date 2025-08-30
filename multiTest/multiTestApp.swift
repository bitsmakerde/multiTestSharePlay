//
//  multiTestApp.swift
//  multiTest
//
//  Created by André Bongartz on 28.08.25.
//

import SwiftUI

@main
struct multiTestApp: App {
    @State private var appModel = AppModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
#if os(visionOS)
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }

        .immersionStyle(selection: .constant(.mixed), in: .mixed)
#endif
    }
}
