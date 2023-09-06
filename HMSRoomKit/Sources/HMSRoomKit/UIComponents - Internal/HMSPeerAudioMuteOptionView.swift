//
//  HMSPeerOptionsView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 05/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSPeerAudioMuteOptionView: View {
    
    @ObservedObject var regularAudioTrackModel: HMSTrackModel

    var body: some View {
        
        HStack {
            Image(assetName: "mic.slash")
                .resizable()
                .frame(width: 20, height: 20)
            Text(regularAudioTrackModel.isMute ? "Request Unmute" : "Mute Audio")
            Spacer(minLength: 0)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
    }
}

struct HMSPeerAudioMuteOptionView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerAudioMuteOptionView(regularAudioTrackModel: HMSTrackModel())
#endif
    }
}
