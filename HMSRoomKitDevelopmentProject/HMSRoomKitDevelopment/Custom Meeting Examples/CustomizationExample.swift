//
//  CustomMeetingView.swift
//  HMSRoomKitDevelopment
//
//  Created by Pawan Dixit on 15/09/2023.
//

import SwiftUI
import HMSRoomKit
import HMSRoomModels

struct CustomizationExample: View {
    
    @ObservedObject var room = HMSRoomModel(roomCode: "qdw-mil-sev")
    
    var body: some View {
        
        Group {
            switch room.roomState {
            case .notJoined:
                Button(action: {
                    Task {
                        try await room.joinSession()
                    }
                }, label: {
                    Text("Start")
                })
            case .inMeeting:
                VStack {
                    HMSPeerLayout()
                    
                    HStack(spacing: 30) {
                        Spacer()
                        Image(systemName: room.isMicMute ? "mic.slash" : "mic")
                            .onTapGesture {
                                room.toggleMic()
                            }
                        
                        Image(systemName: room.isCameraMute ? "video.slash" : "video")
                            .onTapGesture {
                                room.toggleCamera()
                            }
                        
                        Image(systemName: "phone.down.fill")
                            .onTapGesture {
                                Task {
                                    try await room.leaveSession()
                                }
                            }
                        Spacer()
                    }
                    .padding()
                }
            case .leftMeeting:
                HMSEndCallScreen()
            }
        }
        .environmentObject(room)
        .environmentObject(HMSUITheme())
    }
}

struct CustomizationExample_Previews: PreviewProvider {
    static var previews: some View {
        CustomizationExample()
    }
}
