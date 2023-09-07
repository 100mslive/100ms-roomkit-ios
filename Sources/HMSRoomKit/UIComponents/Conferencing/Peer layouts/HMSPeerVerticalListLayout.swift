//
//  HMSPeersVerticalListView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 19/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

public struct HMSPeerVerticalListLayout: View {
    
    @Environment(\.conferenceComponentParam) var conferenceComponentParam
    
    @Environment(\.controlsState) private var controlsState
    
    public init() {}
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    public var body: some View {
        
        let isInsetMode = conferenceComponentParam.tileLayout?.grid.isLocalTileInsetEnabled ?? false
        let visiblePeers = roomModel.visiblePeersInLayout(isUsingInset: isInsetMode)
        
        VStack {
            ForEach(visiblePeers, id: \.self) { peer in
                HMSPeerTile(peerModel: peer, isOverlayHidden: controlsState.wrappedValue == .hidden)
                    .background(.backgroundDefault, cornerRadius: 0)
            }
        }
    }
}

struct HMSPeerVerticalListLayout_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerVerticalListLayout()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}