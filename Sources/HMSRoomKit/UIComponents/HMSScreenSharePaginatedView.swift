//
//  HMSScreenShareTile.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 12/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

public struct HMSScreenSharePaginatedView: View {
    
    @Environment(\.tabPageBarState) var tabPageBarState
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    public init(){}
    
    public var body: some View {
        
        let screenSharingPeers = roomModel.peersSharingScreen.filter{!$0.isLocal}
        
        TabView {
            ForEach(screenSharingPeers, id: \.self) { peer in
                
                WebView(url: URL(string: "https://whiteboard-qa.100ms.live/?endpoint=https://store-qa-in2-ipv6-grpc.100ms.live&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTAzMjg5MDQsInBlZXJfaWQiOiIwYmM0OTk0Ni03MTYzLTQxNjktYmIwMC01OGVmYzJmMjQ5MzkiLCJ1c2VyX2lkIjoiMmY5ZTc4MjMtOTMxMS00ZWQxLThjNjMtNDJmZGQ0MjE5MjM2IiwidXNlcl9uYW1lIjoiUGF3YW4iLCJ1c2VyX3JvbGUiOiJicm9hZGNhc3RlciIsImJvYXJkX2lkIjoiNjVmMDJlOTVkOGE0NTMyMzczMzkwZjcyIiwibmFtZXNwYWNlIjoiNjU4MTRhZmZhOTliM2I1YmM0NDQzYmVlLTY1ZjAyZTgxMThiNmVhNDhhYjc3MGY0NiIsInBlcm1pc3Npb25zIjpbIndyaXRlIiwiYWRtaW4iLCJyZWFkIl19.hwWkHevsKrWo3Eao87mf9WiOa_L7uL637XjVRVWZNWU")!)
                    .gesture(DragGesture())
                
                HMSPeerScreenTile(peerModel: peer)
//                HMSScreenShareView(prominentPeer: peer)
            }
            .padding(.bottom, 35)
        }
        .tabViewStyle(.page)
        .onTapGesture {}
    }
}

struct HMSScreenSharePaginatedView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSScreenSharePaginatedView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1, [.screen, .screen]))
            .environmentObject(HMSPrebuiltOptions())
#endif
    }
}

