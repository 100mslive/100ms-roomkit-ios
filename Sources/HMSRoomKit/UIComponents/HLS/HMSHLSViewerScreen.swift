//
//  HMSHLSViewerScreen.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 11/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels

struct HMSHLSViewerScreen: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        if roomModel.hlsVariants.first?.url != nil {
            HMSHLSPlayerView()
#if !Preview
                .onResolutionChanged { size in
                    print("resolution: \(size)")
                }
                .onPlaybackFailure { error in
                    print("hlsError: \(error.localizedDescription)")
                }
                .onCue { cue in
                    guard let payload = cue.payload, payload.starts(with: "poll") else { return }
                    let pollID = payload.replacingOccurrences(of: "poll:", with: "")
                    
                    NotificationCenter.default.post(name: .init(rawValue: "poll-hls-cue"), object: nil, userInfo: ["pollID" : pollID])
                }
#endif
        }
        else {
            HMSStreamNotStartedView()
        }
    }
}

struct HMSHLSViewerScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSViewerScreen()
            .environmentObject(HMSRoomModel.dummyRoom(1))
            .environmentObject(HMSUITheme())
#endif
    }
}

