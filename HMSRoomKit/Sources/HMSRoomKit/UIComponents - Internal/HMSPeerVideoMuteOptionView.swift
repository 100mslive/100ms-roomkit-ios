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

struct HMSPeerVideoMuteOptionView: View {
    var isMute: Bool
    
    var body: some View {
        
        HStack {
            Image(assetName: "video")
                .resizable()
                .frame(width: 20, height: 20)
            Text(isMute ? "Unmute Video" : "Mute Video")
            Spacer(minLength: 0)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
    }
}

struct HMSPeerVideoMuteOptionView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerVideoMuteOptionView(isMute: true)
#endif
    }
}
