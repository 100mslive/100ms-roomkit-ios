//
//  HMSTopControlStrip.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 01/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSTopControlStrip: View {
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var showCallControls = true
    @State var isParticipantsPresented = false
    
    var body: some View {
        
        let isParticipantListEnabled = conferenceComponentParam.participantList != nil
        
        HStack {
            HStack(spacing: 12) {
                
                HMSCompanyLogoView()
                
                HStack(spacing: 8) {
                    HMSStreamingStatusView()
                    HMSRecordingStatusView()
                    if roomModel.isBeingStreamed == true {
                        HMSParticipantCountStatusView()
                            .onTapGesture {
                                if isParticipantListEnabled {
                                    isParticipantsPresented.toggle()
                                }
                            }
                            .sheet(isPresented: $isParticipantsPresented) {
                                if #available(iOS 16.0, *) {
                                    HMSChatParticipantToggleView(initialPane: .participants).presentationDetents([.large])
                                } else {
                                    HMSChatParticipantToggleView(initialPane: .participants)
                                }
                            }
                    }
                }
            }
            Spacer()
            if showCallControls {
                HStack(spacing: 16) {
                    HMSSwitchCameraButton()
                    HMSAirplayButton {
                        HMSSpeakerButtonView()
                    }
                }
            }
        }
    }
}

struct HMSTopControlStrip_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSTopControlStrip()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environmentObject(HMSRoomInfoModel())
#endif
    }
}

