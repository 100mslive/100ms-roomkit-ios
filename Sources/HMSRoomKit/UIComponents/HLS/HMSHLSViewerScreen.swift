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
        Group {
#if Preview
            HMSHLSPlayerView(url: URL(string: "https://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8")!) { player in
                HMSHLSPlayerControlsView(player: player)
            }
#else
            if roomModel.hlsVariants.first?.url != nil {
                HMSHLSPlayerView(url: URL(string: "https://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8")!) { player in
                    HMSHLSPlayerControlsView(player: player)
                }
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
            }
            else {
                HMSStreamNotStartedView()
            }
#endif
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

