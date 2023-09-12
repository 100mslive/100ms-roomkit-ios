//
//  HMSPreviewRoleScreen.swift
//  HMSRoomKit
//
//  Created by Dmitry Fedoseyev on 24/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSPreviewRoleScreen: View {
    
    @Namespace private var animation
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var topBarGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.64), currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.0)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        
        Group{
            GeometryReader { proxy in
                ZStack {
                    HMSDefaultPreviewTileView(peerName: roomModel.userName)
                    
                    if let videoTrack = roomModel.localVideoTrackModel {
                        HMSVideoTrackView(trackModel: videoTrack)
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .overlay(alignment: .top) {
            HMSTopControlStrip(showCallControls: false)
                .padding([.bottom,.horizontal], 16)
                .transition(.move(edge: .top))
                .background (
                    topBarGradient
                        .edgesIgnoringSafeArea(.all)
                )
        }
        .overlay(alignment: .bottom) {
            HMSPreviewRoleBottomOverlay()
                .matchedGeometryEffect(id: "HMSPreviewBottomOverlay", in: animation)

        }
        .animation(.default, value: roomModel.localVideoTrackModel)
        .background(.white.opacity(0.0001))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
        .onAppear {
            Task {
                try await roomModel.previewChangeRoleRequest()
            }
        }
    }
}

struct HMSPreviewRoleScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPreviewRoleScreen()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
