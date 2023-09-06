//
//  HMSParticipantNameLabel.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSParticipantNameLabel: View {
    
#if !Preview
    @EnvironmentObject var peerModel: HMSPeerModel
#endif
    
    var body: some View {
        
#if Preview
        HMSParticipantNameView(name: "Participant")
#else
        HMSParticipantNameView(name: peerModel.name)
#endif
    }
}

struct HMSParticipantNameLabel_Previews: PreviewProvider {
    static var previews: some View {
        HMSParticipantNameLabel()
    }
}
