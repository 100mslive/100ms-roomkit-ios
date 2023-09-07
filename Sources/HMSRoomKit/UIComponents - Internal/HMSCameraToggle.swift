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
import HMSRoomModels

struct HMSCameraToggle: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        HMSCameraToggleView(isMute: roomModel.isCameraMute)
            .frame(width: 24, height: 24)
            .frame(width: 40, height: 40)
            .controlAppearance(isEnabled: !roomModel.isCameraMute)
            .onTapGesture {
#if !Preview
                roomModel.toggleCamera()
#endif
            }
    }
}

struct HMSCameraToggle_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSCameraToggle()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}
