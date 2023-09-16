//
//  HMSPeersView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 07/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

public struct HMSPeerLayout: View {
    
    public init(){}
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @Environment(\.controlsState) var controlsState
    @Environment(\.tabPageBarState) var tabPageBarState
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @AppStorage("isInsetMinimized") var isInsetMinimized: Bool = false
    @State var shouldInsetRefresh = false
    
    public var body: some View {
        
        let isInsetMode = conferenceComponentParam.tileLayout?.grid.isLocalTileInsetEnabled ?? false
        let prominentRoles = conferenceComponentParam.tileLayout?.grid.prominentRoles ?? []
#if !Preview
        let prominentPeers: [HMSPeerModel] = roomModel.peerModels(withRoles: prominentRoles)
#else
        let prominentPeers: [HMSPeerModel] = []
#endif
        
        let visiblePeers = roomModel.visiblePeersInLayout(isUsingInset: isInsetMode)
        
        Group {
            if visiblePeers.count > 0 {
                HMSPeerGridLayout(prominentPeers: prominentPeers)
            }
            else {
                if let localPeerModel = roomModel.localPeerModel, localPeerModel.role?.canPublish ?? false {
                    HMSPeerTile(peerModel: localPeerModel, isOverlayHidden: controlsState.wrappedValue == .hidden)
                        .background(.backgroundDefault, cornerRadius: 0)
                }
                else {
                    VStack(spacing: 24) {
                        Image(assetName: "hello-icon")
                            .resizable()
                            .foreground(.alertWarning)
                            .frame(width: 64, height: 64)
                        
                        VStack(spacing: 8) {
                            Text("Welcome!")
                                .font(.heading5Semibold24)
                                .foreground(.onSurfaceHigh)
                            
                            Text("Sit back and relax.")
                                .font(.body1Regular16)
                                .foreground(.onSurfaceMedium)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.backgroundDim, cornerRadius: 0)
                }
            }
        }
        .overlay(alignment: .center) {
            if isInsetMode {
                if roomModel.localAudioTrackModel != nil && visiblePeers.count > 0 {
                    if let localPeerModel = roomModel.localPeerModel {
                        if roomModel.spotlightedPeer != localPeerModel && !roomModel.pinnedPeers.contains(localPeerModel) {
                            HMSInsetView(size: CGSize(width: 104, height: isInsetMinimized ? 28 : 186), bottomOffset: tabPageBarState.wrappedValue == .visible ? 75 : 75 - 32, isRefreshed: $shouldInsetRefresh) {
                                Group {
                                    if isInsetMinimized {
                                        HMSMinimizedInsetTile(isInsetMinimized: $isInsetMinimized)
                                            .onAppear() {
                                                shouldInsetRefresh.toggle()
                                            }
                                    }
                                    else {
                                        HMSInsetTile(peerModel: localPeerModel)
                                            .frame(width: 104, height: 186)
                                            .cornerRadius(8)
                                            .background(.surfaceDefault, cornerRadius: 8)
                                            .onAppear() {
                                                shouldInsetRefresh.toggle()
                                            }
                                    }
                                }
                            }
                            .onChange(of: controlsState.wrappedValue) { _ in
                                shouldInsetRefresh.toggle()
                            }
                            .animation(.default, value: isInsetMinimized)
                        }
                    }
                }
            }
        }
    }
}

struct HMSPeerCallLayout_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerLayout()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1, [.screen, .prominent, .screen]))
            .environmentObject(HMSRoomInfoModel())
            .environmentObject(HMSPrebuiltOptions())
#endif
    }
}
