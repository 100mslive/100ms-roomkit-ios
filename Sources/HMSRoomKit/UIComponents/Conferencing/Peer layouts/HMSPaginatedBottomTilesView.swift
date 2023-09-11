//
//  HMSPaginatedBottomTilesView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 22/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

struct HMSPaginatedBottomTilesView: View {
    
    let peers: [HMSPeerModel]
    
    @Environment(\.tabPageBarState) var tabPageBarState
    @Environment(\.controlsState) private var controlsState
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        TabView {
            Group {
                let chunks = Array(peers.chunks(ofCount: 2))
                
                ForEach(chunks, id:\.self) { chunk in
                    TallVGrid(items: Array(chunk), idKeyPath: \.self, numOfColumns: 2, vhSpacing: 8, isTrailing: peers.count > 2, maxItemInOnePage: 2, content: { peer in
                        
                        HMSPeerTile(peerModel: peer, isOverlayHidden: controlsState.wrappedValue == .hidden)
                            .background(.backgroundDefault, cornerRadius: 0)
                    })
                }
            }
            .padding(.bottom, 35)
        }
        .tabViewStyle(.page)
        .onAppear() {
            tabPageBarState.wrappedValue = .visible
        }
        .onDisappear() {
            tabPageBarState.wrappedValue = .hidden
        }
    }
}

struct HMSPaginatedBottomTilesView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPaginatedBottomTilesView(peers: [HMSPeerModel(), HMSPeerModel(), HMSPeerModel()])
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
