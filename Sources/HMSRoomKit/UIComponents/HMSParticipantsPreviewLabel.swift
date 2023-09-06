//
//  HMSPreviewParticipantsView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSParticipantsPreviewLabel: View {
    
    // Environment
    let peerCount: Int
    
    var body: some View {
        HMSPreviewParticipantsLabelView(peerCount: peerCount)
    }
}

struct HMSParticipantsPreviewLabel_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSParticipantsPreviewLabel(peerCount: 3)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
