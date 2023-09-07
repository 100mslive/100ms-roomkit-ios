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

struct HMSRecordingStatusView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        if roomModel.recordingState == .recording {
            Image(assetName:"record-on")
                .foreground(.errorDefault)
        }
        else if roomModel.recordingState == .initializing {
            HMSLoadingView {
                Image(assetName: "loading-record")
            }
        }
    }
}

struct HMSRecordingStatus_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSRecordingStatusView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}
