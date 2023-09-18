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

import HMSRoomKit
import HMSRoomModels

struct CustomMeetingView: View {
    
    @ObservedObject var room = HMSRoomModel(roomCode: "qdw-mil-sev")
    
    var body: some View {
        
        Group {
            switch room.roomState {
            case .none:
                HMSPreviewScreen()
            case .meeting:
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
                                    try await room.leave()
                                }
                            }
                        Spacer()
                    }
                    .padding()
                }
                .environment(\.conferenceParams, .init(tileLayout: .defaultGrid))
            case .leave:
                HMSEndCallScreen()
            }
        }
        .environmentObject(room)
        .environmentObject(HMSUITheme())
    }
}

#Preview {
    CustomMeetingView()
}
