//
//  HMSPreviewTopOverlay.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 21/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import Combine

import HMSSDK
import HMSRoomModels

struct HMSPreviewBottomOverlay: View {
    
    @Environment(\.previewParams) var previewComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @State var showDeviceSettings = false
    @State private var cancellable: AnyCancellable?
    
    @State var isJoining = false
    
    @Environment(\.userStreamingState) var userStreamingState
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                
                if roomModel.previewAudioTrack != nil {
                    HMSMicToggle()
                }
                
                if roomModel.previewVideoTrack != nil {
                    HMSCameraToggle()
                    HMSSwitchCameraButton()
                }
                
                Spacer()
                HMSAirplayButton {
                    HMSSpeakerButtonView()
                }
            }

            HStack {
                HMSJoinNameLabel()
                    .onTapGesture {
                        // it's here to stop keyboard dismissal by tapping text field
                    }
                HMSJoinButton(isJoining: $isJoining)
                    .onTapGesture {
#if !Preview
                        guard !roomModel.userName.isEmpty else { return }
                        
                        Task {
                            
                            isJoining = true
                            do {
                                try await roomModel.joinSession()
                            }
                            catch {
                                isJoining = false
                                return
                            }
                            isJoining = false
                            
                            if previewComponentParam.joinButtonType == .goLive && !roomModel.isBeingStreamed {
                                
                                userStreamingState.wrappedValue = .starting
                                
                                cancellable = roomModel.$isBeingStreamed.dropFirst().sink { isBeingStreamed in
                                    if isBeingStreamed {
                                        userStreamingState.wrappedValue = .none
                                        roomModel.roomState = .inMeeting
                                    }
                                    cancellable = nil
                                }
                                do {
                                    try await roomModel.startStreaming()
                                    if roomModel.isBeingStreamed {
                                        roomModel.roomState = .inMeeting
                                    }
                                } catch {
                                    userStreamingState.wrappedValue = .none
                                    cancellable = nil
                                    try await roomModel.leaveSession()
                                }
                            }
                            else {
                                roomModel.roomState = .inMeeting
                            }
                        }
#endif
                    }
            }
        }
        .padding(16)
        .background(.backgroundDefault, cornerRadius: 16, corners: [.topLeft, .topRight], ignoringEdges: .all)
    }
}

struct HMSPreviewBottomOverlay_Previews: PreviewProvider {
    
    static var previews: some View {
#if Preview
        @State var isStartingStream = false
        
        HMSPreviewBottomOverlay()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
