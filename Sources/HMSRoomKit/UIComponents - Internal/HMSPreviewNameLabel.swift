//
//  HMSParticipantNameLabel.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSPreviewNameLabel: View {
    
    @ObservedObject var peerModel: HMSPeerModel
    
    var body: some View {
        HMSParticipantNameLabelView(name: nil, wifiStrength: peerModel.displayQuality)
    }
}

struct HMSPreviewNameLabel_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPreviewNameLabel(peerModel: HMSPeerModel())
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}
