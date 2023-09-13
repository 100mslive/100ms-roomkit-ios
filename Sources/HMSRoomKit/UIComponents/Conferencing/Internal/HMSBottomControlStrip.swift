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
    
    @Environment(\.conferenceComponentParam) var conferenceComponentParam
    
    @Environment(\.menuContext) var menuContext
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var options: HMSPrebuiltOptions
    
    @Binding var isChatPresented: Bool
    @State var isSessionMenuPresented = false
    
    @State var isOptionsSheetPresented: Bool = false
    
    var body: some View {
        
        let isChatEnabled = conferenceComponentParam.chat != nil
        
        let isParticipantListEnabled = conferenceComponentParam.participantList != nil
        let isBrbEnabled = conferenceComponentParam.brb != nil
        let isHandRaiseEnabled = conferenceComponentParam.onStageExperience != nil
        let canStartRecording = roomModel.userCanStartStopRecording
        let canScreenShare = roomModel.userCanShareScreen
        
        
        if let localPeerModel = roomModel.localPeerModel {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                HStack(spacing: 24) {
                    HMSEndCallButton(type: .hls)
                    
                    if roomModel.localAudioTrackModel != nil {
                        HMSMicToggle()
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                    }
                    else {
                        HMSHandRaisedToggle()
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                    }
                    
                    if roomModel.localVideoTrackModel != nil {
                        HMSCameraToggle()
                    }
                    
                    if isChatEnabled {
                        HMSChatToggleView()
                            .controlAppearance(isEnabled: !isChatPresented)
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                            .onTapGesture {
                                isChatPresented.toggle()
                            }
                    }
                    
                    if isParticipantListEnabled || isBrbEnabled || isHandRaiseEnabled || canStartRecording || canScreenShare {
                        HMSOptionsToggleView()
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                            .onTapGesture {
                                isSessionMenuPresented.toggle()
                            }
                            .sheet(isPresented: $isSessionMenuPresented, onDismiss: {
                                menuContext.wrappedValue = .none
                            }) {
                                HMSSheet {
                                    HMSOptionSheetView()
                                        .environmentObject(currentTheme)
                                        .environmentObject(options)
                                        .environmentObject(roomModel)
                                        .environmentObject(localPeerModel)
                                }
                                .edgesIgnoringSafeArea(.all)
                            }
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
        HMSBottomControlStrip(isChatPresented: .constant(false))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environmentObject(HMSPrebuiltOptions())
            .environment(\.chatBadgeState, .constant(.badged))
#endif
    }
}
