//
//  HMSHLSViewerScreen.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 11/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels

public struct HMSHLSViewerScreen: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @State var hlsPlaybackPreference: HMSHLSPreferences = .init(isControlsHidden: true)
    
    @State var streamFinished = false
    @State var preparingToPlay = true
    @State var isBuffering = false
    
    @Binding var isMaximized: Bool
    
    public var body: some View {
        Group {
#if Preview
            HMSHLSPlayerView(url: URL(string: "https://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8")!) { player in
                HMSHLSPlayerControlsView(player: player, isMaximized: $isMaximized)
            }
#else
            if roomModel.hlsVariants.first?.url != nil {
                
                HMSHLSPlayerView { player in
                    HMSHLSPlayerControlsView(player: player, isMaximized: $isMaximized)
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
                .onPlaybackStateChanged { state in
                    
                    isBuffering = state == .buffering
                    
                    if state == .playing {
                        streamFinished = false
                        preparingToPlay = false
                    }
                    else if state == .stopped {
                        streamFinished = true
                    }
                }
                .onAppear() {
                    preparingToPlay = true
                }
                .overlay(content: {
                    if preparingToPlay || isBuffering {
                        HMSLoadingView {
                            Image(assetName: "progress-indicator")
                                .foreground(.primaryDefault)
                        }
                    }
                })
                .overlay(alignment: .center) {
                    if streamFinished {
                        HMSNoStreamView(state: streamFinished ? .streamEnded : .streamYetToStart)
                            .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
                    }
                }
            }
            else {
                HMSNoStreamView(state: .streamYetToStart)
            }
#endif
        }
        .environment(\.hlsPlayerPreferences, $hlsPlaybackPreference)
    }
}

struct HMSHLSViewerScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSViewerScreen(isMaximized: .constant(false))
            .environmentObject(HMSRoomModel.dummyRoom(1))
            .environmentObject(HMSUITheme())
#endif
    }
}

