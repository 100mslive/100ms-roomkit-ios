//
//  HMSPeerProminenceLayout.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 20/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSScreenProminenceLayout: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @Environment(\.controlsState) var controlsState
    
    @AppStorage("isInsetMinimized") var isInsetMinimized: Bool = false
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @Namespace private var animation

    @State var isExpanded = false
    @State var wasInsetAlreadyMinimized = false
    
    var body: some View {
        
        GeometryReader { geo in
            
            if verticalSizeClass == .regular {
                VStack(spacing: 0) {
                    screenView
                    tilesView
                        .frame(height: geo.size.height * 0.33)
                }
            }
            else {
                HStack(spacing: 0) {
                    screenView
                    tilesView
                        .padding(.horizontal, 10)
                        .frame(width: geo.size.width * 0.33)
                }
            }
        }
        .onAppear() {
            withAnimation {
                wasInsetAlreadyMinimized = isInsetMinimized
                isInsetMinimized = true
            }
        }
        .onDisappear() {
            withAnimation {
                if !wasInsetAlreadyMinimized {
                    isInsetMinimized = false
                }
                
                if isExpanded {
                    controlsState.wrappedValue = .visible
                }
            }
        }
        .onChange(of: isExpanded) { isExpanded in
            withAnimation {
                controlsState.wrappedValue = isExpanded ? .hidden : .visible
            }
        }
    }
    
    var screenView: some View {
        HMSScreenSharePaginatedView()
            .overlay(alignment: .topTrailing) {
                HMSExpandIconView()
                    .frame(width: 16, height: 16)
                    .frame(width: 40, height: 40)
                    .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                    .foreground(.onSurfaceHigh)
                    .background(.white.opacity(0.0001))
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
                    .padding()
            }
    }
    
    @ViewBuilder
    var tilesView: some View {
        
        let isInsetMode = conferenceComponentParam.tileLayout?.grid.isLocalTileInsetEnabled ?? false
        let visiblePeers = roomModel.visiblePeersInLayout(isUsingInset: isInsetMode)
        let screenSharingPeers = roomModel.peersSharingScreen.filter{!$0.isLocal}
        
        if !isExpanded {
            HMSPaginatedBottomTilesView(peers: visiblePeers.sorted{first,second in
                
                if screenSharingPeers.contains(second) && roomModel.highlightedPeers.contains(first) {
                    return false
                }
                
                return screenSharingPeers.contains(first) || roomModel.highlightedPeers.contains(first)
            })
        }
    }
}


struct HMSScreenProminenceLayout_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSScreenProminenceLayout()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1, [.screen, .screen]))
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomInfoModel())
#endif
    }
}
