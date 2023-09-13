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

struct HMSParticipantScreenNameLabel: View {
    
    @ObservedObject var peerModel: HMSPeerModel
    
    var body: some View {
        
        HMSParticipantScreenNameLabelView(name: peerModel.name)
    }
}

struct HMSParticipantScreenNameLabel_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSParticipantScreenNameLabel(peerModel: HMSPeerModel())
            .environmentObject(HMSUITheme())
#endif
    }
}
