//
//  PreviewScreen.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 12/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSPreviewScreenLiveStreaming: View {
    
    @Namespace private var animation
    
    @Environment(\.previewParams) var previewComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @State var name: String = ""
    
    @State var isVirtualBackgroundControlsPresent = false
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            if roomModel.localVideoTrackModel != nil {
                
                VStack(spacing: 0) {
                    HMSPreviewTile()
                        .ignoresSafeArea(.keyboard)
                        .edgesIgnoringSafeArea([.top, .bottom])
                        .overlay(alignment: .top) {
                            if !isVirtualBackgroundControlsPresent {
                                HMSPreviewTopOverlay()
                                    .padding(.vertical, 8)
                                    .matchedGeometryEffect(id: "HMSPreviewTopOverlay", in: animation)
                                    .background (
                                        LinearGradient(
                                            gradient: Gradient(colors: [currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(1.0), currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.0)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            }
                        }
                    
                    if isVirtualBackgroundControlsPresent {
                        HMSVirtualBackgroundControlsSheetView(isVirtualBackgroundControlsPresent: $isVirtualBackgroundControlsPresent)
                            .frame(height: 400)
                    }
                }
            }
            else {
                VStack {
                    Spacer(minLength: 0)
                    HMSPreviewTopOverlay()
                        .matchedGeometryEffect(id: "HMSPreviewTopOverlay", in: animation)
                    Spacer(minLength: 0)
                }
            }
        }
        .overlay(alignment: .top) {
            HStack {
                HMSBackButtonView()
                    .padding(.leading)
                    .onTapGesture {
                        Task {
#if !Preview
                            try await roomModel.leaveSession()
#endif
                        }
                    }
                Spacer()
            }
        }
        .overlay(alignment: .bottom) {
            
            if !isVirtualBackgroundControlsPresent {
                
                VStack {
                    
                    if let localPeerModel = roomModel.localPeerModel {
                        HStack {
                            HMSPreviewNameLabel(peerModel: localPeerModel)
                                .padding(9)
                            
                            Spacer(minLength: 0)
                        }
                    }
                    
                    HMSPreviewBottomOverlay(isVirtualBackgroundControlsPresent: $isVirtualBackgroundControlsPresent)
                        .matchedGeometryEffect(id: "HMSPreviewBottomOverlay", in: animation)
                }
            }
        }
        .animation(.default, value: roomModel.localVideoTrackModel)
        .background(.white.opacity(0.0001))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
        .alert(isPresented: Binding(get: {
            guard let lastError = roomModel.lastError as? HMSError else { return false }
            return lastError.isTerminal
        }, set: { _ in
            Task {
                try await roomModel.leaveSession()
            }
        }), content: {
            Alert(title: Text("Error"), message: Text(roomModel.lastError?.localizedDescription ?? ""))
        })
        .onChange(of: roomModel.localAudioTrackModel) { model in
            roomModel.toggleMic()
        }
        .onChange(of: roomModel.localVideoTrackModel) { model in
            roomModel.toggleCamera()
        }
    }
}

struct HMSPreviewScreenLiveStreaming_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPreviewScreenLiveStreaming()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
