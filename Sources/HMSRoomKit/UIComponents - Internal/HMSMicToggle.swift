//
//  HMSMicToggle.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSMicToggle: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        HMSMicToggleView(isMute: roomModel.isMicMute)
            .frame(width: 24, height: 24)
            .frame(width: 40, height: 40)
            .controlAppearance(isEnabled: !roomModel.isMicMute)
            .onTapGesture {
#if !Preview
                roomModel.toggleMic()
#endif
            }
    }
}

struct HMSMicToggle_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSMicToggle()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}
