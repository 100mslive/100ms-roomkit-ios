//
//  HMSTopControlStrip.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 01/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSTopControlStrip: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var showCallControls = true
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                
                HMSCompanyLogoView()

                HStack(spacing: 8) {
                    HMSStreamingStatusView()
                    HMSRecordingStatusView()
                    if roomModel.isBeingStreamed == true {
                        HMSParticipantCountStatusView()
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
#endif
    }
}

