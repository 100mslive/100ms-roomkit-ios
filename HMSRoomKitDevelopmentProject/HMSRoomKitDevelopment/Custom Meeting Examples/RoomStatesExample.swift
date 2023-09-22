//
//  CustomMeetingRoomStates.swift
//  HMSRoomKitDevelopment
//
//  Created by Pawan Dixit on 22/09/2023.
//

import SwiftUI
import HMSRoomKit
import HMSRoomModels

struct RoomStatesExample: View {
    
    @ObservedObject var room = HMSRoomModel(roomCode: "qdw-mil-sev")
    
    var body: some View {
        
        Group {
            switch room.roomState {
            case .none:
                HMSPreviewScreen()
            case .meeting:
                HMSConferenceScreen()
            case .leave:
                HMSEndCallScreen()
            }
        }
        .environmentObject(room)
        .environmentObject(HMSUITheme())
    }
}

struct RoomStatesExample_Previews: PreviewProvider {
    static var previews: some View {
        RoomStatesExample()
    }
}
