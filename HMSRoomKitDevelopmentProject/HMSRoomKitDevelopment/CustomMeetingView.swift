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

struct CustomMeetingView: View {
    
    let room = HMSRoomModel(roomCode: "qdw-mil-sev")
    
    var body: some View {
        
        VStack {
            HMSPreviewScreen { screen in
                screen.title = "title"
                screen.subTitle = "subtitle"
                screen.goLiveButtonLabel = "goLiveButtonLabel"
                screen.joinButtonLabel = "joinButtonLabel"
                screen.joinButtonType = .join
            }
            
            HMSConferenceScreen { screen in
                screen.brb = .default
                screen.tileLayout = .init(grid: .default)
                screen.onStageExperience = nil
                screen.chat = .default
                screen.participantList = .default
            }
        }
        .environmentObject(room)
        .environmentObject(HMSUITheme())
    }
}

#Preview {
    CustomMeetingView()
}
