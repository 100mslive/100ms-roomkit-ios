//
//  ContentView.swift
//  HMSRoomKitDevelopmentProject
//
//  Created by Pawan Dixit on 13/09/2023.
//

import SwiftUI
#if !Development
import HMSRoomKit
#endif

struct ContentView: View {
    
    @State var roomCode = ""
    @State var isMeetingViewPresented = false
    
    var body: some View {
        
        if isMeetingViewPresented && !roomCode.isEmpty {
            
            HMSPrebuiltView(roomCode: roomCode, onDismiss: {
                isMeetingViewPresented = false
            })
            .screenShare(appGroupName: "group.live.100ms.roomkit.development", screenShareBroadcastExtensionBundleId: "live.100ms.videoapp.roomkit.Screenshare")
        }
        else {
            JoiningView(roomCode: $roomCode,
                        isMeetingViewPresented: $isMeetingViewPresented)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
