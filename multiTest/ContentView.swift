//
//  ContentView.swift
//  multiTest
//
//  Created by André Bongartz on 28.08.25.
//

import ARKit
import RealityKit
import SwiftUI

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            #if os(iOS)
            ImmersiveView()
                .environment(appModel)
            #endif
            #if os(visionOS)
            ToggleImmersiveSpaceButton(modelURL: URL(string: "toy_car")!)
                
            #endif
        }
        .padding()
        .task {
            await appModel.observeGroupSessions()
        }
    }
}

#Preview {
    ContentView()
}
