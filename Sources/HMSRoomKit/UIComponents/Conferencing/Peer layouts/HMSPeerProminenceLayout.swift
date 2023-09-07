//
//  HMSPeerProminenceLayout.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 20/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

struct HMSPeerProminenceLayout: View {
    
    @Environment(\.conferenceComponentParam) var conferenceComponentParam
    
    @Environment(\.tabPageBarState) var tabPageBarState
    
    let prominentPeers: [HMSPeerModel]
    
    @Environment(\.controlsState) private var controlsState

    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        let isInsetMode = conferenceComponentParam.tileLayout?.grid.isLocalTileInsetEnabled ?? false
        let visiblePeers = roomModel.visiblePeersInLayout(isUsingInset: isInsetMode)
        
        let nonProminentPeers: [HMSPeerModel] = visiblePeers.filter{!prominentPeers.contains($0)}
        
        GeometryReader { geo in
            VStack(spacing: 0) {
                TabView {
                    ForEach(prominentPeers, id: \.self) { peer in
                        
                        HMSPeerTile(peerModel: peer, isOverlayHidden: controlsState.wrappedValue == .hidden)
                            .background(.backgroundDefault, cornerRadius: 0)
                    }
                    .padding(.bottom, 35)
                }
                .tabViewStyle(.page)
                
                HMSPaginatedBottomTilesView(peers: nonProminentPeers)
                    .transition(.move(edge: .bottom))
                    .frame(height: nonProminentPeers.count > 0 ? geo.size.height * 0.33 : 0)
                    .opacity(nonProminentPeers.count > 0 ? 1 : 0)
            }
        }
        .animation(.default, value: nonProminentPeers.count)
    }
}

struct HMSPeerProminenceLayout_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerProminenceLayout(prominentPeers: HMSRoomModel.prominentPeers(2))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3, [.prominent, .prominent]))
            .environmentObject(HMSRoomInfoModel())
            .environment(\.conferenceComponentParam, EnvironmentValues.HMSConferenceComponentParamKey.defaultValue)
#endif
    }
}
