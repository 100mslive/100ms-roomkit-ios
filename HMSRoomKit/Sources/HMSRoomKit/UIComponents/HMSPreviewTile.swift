//
//  HMSLocalPeerView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSPreviewTile: View {
    
    // Environment
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                HMSDefaultPreviewTileView(peerName: roomModel.userName)
                
                if let videoTrack = roomModel.localVideoTrackModel {
                    HMSVideoTrackView(trackModel: videoTrack)
                }
                
//                Color.white
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
//            .clipShape(RoundedRectangle(cornerRadius: 16))
            .background(.backgroundDefault, cornerRadius: 0)
//            .overlay(alignment: .topTrailing) {
//                Group {
//                    if let audioTrack = roomModel.previewAudioTrack {
//                        HMSAudioTrackView(trackModel: audioTrack)
//                    }
//                }
//                .padding(10)
//            }
        }
    }
}

struct HMSPreviewTile_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPreviewTile()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}
