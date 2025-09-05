//
//  ContentView.swift
//  multiTest
//
//  Created by André Bongartz on 28.08.25.
//

import ARKit
import RealityKit
import SwiftUI
import GroupActivities

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @StateObject var groupStateObserver = GroupStateObserver()
    
    let size:CGFloat = 120
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
            
            // show only the button if you have an facetimecall
            if appModel.immersiveSpaceState == .open  {
                ShareLink(item: SharedActivity(), preview: SharePreview("share now UDC"))
                    .frame(width: size, height: size, alignment: .center)
                    //.buttonStyle(.plain)
                    .background(.regularMaterial, in: Circle())
                    .hoverEffect()
                if appModel.groupSession == nil && groupStateObserver.isEligibleForGroupSession {
                    Button(action: {
                        appModel.startShareSession()
                    }) {
                        Text("Start session")
                    }
                } else if appModel.groupSession != nil {
                    Text("You are in a session")
                } else {
                    Text("Not eligible for group session")
                }
            }
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
