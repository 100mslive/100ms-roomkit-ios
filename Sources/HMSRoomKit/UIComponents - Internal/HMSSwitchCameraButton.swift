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

struct HMSSwitchCameraButton: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        if roomModel.localVideoTrackModel != nil {
            
            let isEnabled = !(roomModel.isCameraMute)
            
            HMSSwitchCameraButtonView(isEnabled: isEnabled)
                .onTapGesture {
                    guard isEnabled else { return }
#if !Preview
                    roomModel.switchCamera()
#endif
                }
        }
    }
}

struct HMSSwitchCameraButton_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSSwitchCameraButton()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
