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

struct HMSStreamingStatusView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        if roomModel.isBeingStreamed == true {
            HMSLiveLabel(showsCircle: false)
                .frame(height: 24)
                .background(.errorDefault, cornerRadius: 4)
        }
    }
}

struct HMSStreamingStatusView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSStreamingStatusView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}
