//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSHandRaisedToggle: View {
    
    @EnvironmentObject var localPeerModel: HMSPeerModel
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        Image(assetName: "hand-raise-icon")
            .foreground(.onSurfaceHigh)
            .frame(width: 24, height: 24)
            .frame(width: 40, height: 40)
            .background(.white.opacity(0.0001))
            .onTapGesture {
                Task {
                    try await roomModel.setUserStatus(localPeerModel.status == .handRaised ? .none : .handRaised)
                }
            }
            .controlAppearance(isEnabled: localPeerModel.status != .handRaised)
        
    }
}

struct HMSHandRaisedToggle_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHandRaisedToggle()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
