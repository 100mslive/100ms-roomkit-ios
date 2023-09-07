//
//  HMSScreenShareTile.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 12/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

struct HMSScreenSharePaginatedView: View {
    
    @Environment(\.tabPageBarState) var tabPageBarState
    
    let screenSharingPeers: [HMSPeerModel]
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        TabView {
            ForEach(screenSharingPeers, id: \.self) { peer in
                HMSPeerScreenTile(peerModel: peer)
//                HMSScreenShareView(prominentPeer: peer)
            }
            .padding(.bottom, 35)
        }
        .tabViewStyle(.page)
    }
}

struct HMSScreenShareTile_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSScreenSharePaginatedView(screenSharingPeers: HMSRoomModel.screenSharingPeers)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1, [.screen, .screen]))
            .environmentObject(HMSPrebuiltOptions())
#endif
    }
}

