//
//  HMSBottomControlStrip.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 01/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSBottomControlStrip: View {
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @Environment(\.menuContext) var menuContext
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @Binding var isChatPresented: Bool
    
    @State var isOptionsSheetPresented: Bool = false
    
    let isHLSViewer: Bool
    
    var body: some View {
        
        let isChatEnabled = conferenceComponentParam.chat != nil
        
        let isParticipantListEnabled = conferenceComponentParam.participantList != nil
        let isBrbEnabled = conferenceComponentParam.brb != nil
        let isHandRaiseEnabled = conferenceComponentParam.isHandRaiseEnabled
        let canStartRecording = roomModel.userCanStartStopRecording
        let canScreenShare = roomModel.userCanShareScreen
        
        let chatInitialState = conferenceComponentParam.chat?.initialState ?? .close
        
        if let localPeerModel = roomModel.localPeerModel {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                HStack(spacing: 24) {
                    HMSEndCallButton(type: .webrtc)
                    
                    if roomModel.localAudioTrackModel != nil {
                        HMSMicToggle()
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                    }
                    else if isHandRaiseEnabled {
                        HMSHandRaisedToggle()
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                    }
                    
                    if roomModel.localVideoTrackModel != nil {
                        HMSCameraToggle()
                    }
                    
                    if isChatEnabled && !isHLSViewer {
                        HMSChatToggleView()
                            .controlAppearance(isEnabled: !isChatPresented)
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                            .onTapGesture {
                                isChatPresented.toggle()
                            }
                    }
                    
                    if isParticipantListEnabled || isBrbEnabled || isHandRaiseEnabled || canStartRecording || canScreenShare {
                        HMSOptionsToggleView(isHLSViewer: isHLSViewer)
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                    }
                }
                Spacer(minLength: 0)
            }
            .environmentObject(localPeerModel)
        }
    }
}

struct HMSBottomControlStrip_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSBottomControlStrip(isChatPresented: .constant(false), isHLSViewer: true)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environmentObject(HMSPrebuiltOptions())
            .environment(\.chatBadgeState, .constant(.badged))
#endif
    }
}
