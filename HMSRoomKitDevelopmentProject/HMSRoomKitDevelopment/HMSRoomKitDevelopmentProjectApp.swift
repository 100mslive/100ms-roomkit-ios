//
//  HMSRoomKitDevelopmentProjectApp.swift
//  HMSRoomKitDevelopmentProject
//
//  Created by Pawan Dixit on 13/09/2023.
//

import SwiftUI

@main
struct HMSRoomKitDevelopmentProjectApp: App {
    var body: some Scene {
        WindowGroup {
#if Development
            ContentView()
#else
            CustomMeetingView()
#endif
        }
    }
}
