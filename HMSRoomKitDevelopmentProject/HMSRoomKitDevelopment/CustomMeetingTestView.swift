//
//  CustomMeetingView.swift
//  HMSRoomKitDevelopment
//
//  Created by Pawan Dixit on 15/09/2023.
//

import SwiftUI
#if !Development
import HMSRoomKit
import HMSRoomModels
#endif

struct CustomMeetingTestView: View {
    
    let room = HMSRoomModel(roomCode: "qdw-mil-sev")
    
    var body: some View {
        
        TabView {
            
            VStack {
//                HMSPreviewScreen { screen in
//                    screen.title = "title"
//                    screen.subTitle = "subtitle"
//                    screen.goLiveButtonLabel = "goLiveButtonLabel"
//                    screen.joinButtonLabel = "joinButtonLabel"
//                    screen.joinButtonType = .join
//                }
//                
                HMSPreviewScreen()
            }
            .environment(\.previewParams, .init(title: "Hello Kitty"))
            .tabItem { Text("Preview") }
            
            Group {
                VStack {
//                    HMSConferenceScreen { screen in
//                        screen.brb = .default
//                        screen.tileLayout = .init(grid: .default)
//                        screen.onStageExperience = .none
//                        screen.chat = .default
//                        screen.participantList = .default
//                    }
                    
                    HMSConferenceScreen()
                }
                .tabItem { Text("Conference") }
                
                VStack {
                    HMSPeerLayout()
                }
                .tabItem { Text("Layout") }
            }
            .environment(\.conferenceParams, .init(chat: .none, tileLayout: .none, onStageExperience: .none, brb: .none, participantList: .none))
        }
        .environmentObject(room)
        .environmentObject(HMSUITheme())
    }
}

#Preview {
    CustomMeetingTestView()
}
