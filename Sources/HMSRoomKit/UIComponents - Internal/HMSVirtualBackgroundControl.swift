//
//  HMSMicToggle.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSVirtualBackgroundControl: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    let onTap: ()->Void
    
    var body: some View {
        
        if roomModel.localVideoTrackModel != nil {
            
            let isEnabled = !(roomModel.isCameraMute)
            
            HMSVirtualBackgroundButtonView(isEnabled: isEnabled)
                .onTapGesture {
                    guard isEnabled else { return }
                    onTap()
                }
        }
    }
}

struct HMSVirtualBackgroundControl_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSVirtualBackgroundControl{}
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
