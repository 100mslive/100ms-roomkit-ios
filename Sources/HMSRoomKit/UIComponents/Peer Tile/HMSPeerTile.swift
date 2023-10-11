//
//  HMSLocalPeerView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

public struct HMSPeerTile: View {
    
    // Environment keys
    @Environment(\.menuContext) private var menuContext
    @Environment(\.peerTileAppearance) var peerTileAppearance
    
    // Environment objects
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var theme: HMSUITheme
    
    // Param
    @ObservedObject var peerModel: HMSPeerModel
    
    public init(peerModel: HMSPeerModel) {
        self.peerModel = peerModel
    }
    
    public var body: some View {
        
        // Transitory states
        let audioTrackModel = peerModel.regularAudioTrackModel
        let regularVideoTrackModel = peerModel.regularVideoTrackModel
        let isVideoDegraded = peerModel.isVideoDegraded
        
        GeometryReader { proxy in
            ZStack {
                HMSDefaultTileView(peerModel: peerModel, compactMode: peerTileAppearance.mode.wrappedValue == .compact)
                
                if let regularVideoTrackModel = regularVideoTrackModel {
                    HMSVideoTrackView(trackModel: regularVideoTrackModel, isDegraded: isVideoDegraded)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            
            .overlay(alignment: .bottom) {
                HStack {
                    if peerTileAppearance.mode.wrappedValue == .full {
                        HMSParticipantNameLabel(peerModel: peerModel)
                    }
                    
                    Spacer()
                    
                    HMSPeerOptionsButtonView(peerModel: peerModel) {
                        menuContext.wrappedValue = .none
                    } label: {
                        Image(assetName: "vertical-ellipsis")
                            .resizable()
                            .frame(width: 3.33, height: 15)
                            .foreground(.onSurfaceHigh)
                            .frame(width: 28, height: 28)
                            .background(.backgroundDim, cornerRadius: 8, opacity: 0.6)
                            .frame(height: !peerTileAppearance.isOverlayHidden.wrappedValue ? nil : 0)
                            .opacity(!peerTileAppearance.isOverlayHidden.wrappedValue ? 1 : 0)
                    }
                    .animation(nil, value: peerTileAppearance.isOverlayHidden.wrappedValue)
                }
                .padding(8)
            }
            .overlay(alignment: .top) {
                HStack {
                    switch peerModel.status {
                    case .beRightBack:
                        HMSBRBIconView()
                    case .handRaised:
                        HMSHandRaisedIconView()
                    case .none:
                        EmptyView()
                    }
                    Spacer()
                    if let audioTrackModel = audioTrackModel {
                        HMSAudioTrackView(trackModel: audioTrackModel)
                            .environmentObject(peerModel)
                    }
                }
                .padding(10)
            }
//            .clipShape(RoundedRectangle(cornerRadius: 8))
//            .background(.backgroundDefault, cornerRadius: 8)
        }
    }
}

struct HMSPeerTile_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerTile(peerModel: HMSRoomModel.localPeer)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environmentObject(HMSRoomInfoModel())
#endif
    }
}
