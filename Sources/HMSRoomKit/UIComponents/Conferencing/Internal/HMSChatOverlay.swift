//
//  HMSChatOverlay.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 31/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels

struct HMSChatOverlay: View {
    
    @Environment(\.controlsState) var controlsState
    @Environment(\.tabPageBarState) var tabPageBarState
    @Environment(\.keyboardState) var keyboardState
    
    @EnvironmentObject var roomKitModel: HMSRoomKitModel
    
    @Binding var isChatPresented: Bool
    let isHLSViewer: Bool
    let isChatOverlay: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 8) {
                
                if isChatOverlay {
                    // transparent chat
                    if isChatPresented {
                        
                        HMSTransparentChatScreen(isTransparentMode: true)
                            .frame(maxHeight: 332)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(isHLSViewer ? [.horizontal, .top] : [.horizontal, .vertical], 8)
                            .padding(.bottom, keyboardState.wrappedValue == .hidden ? 0 : 8)
                    }
                }
                
                if keyboardState.wrappedValue == .hidden {
                    HMSNotificationStackView()
                        .environmentObject(roomKitModel)
                        .padding([.horizontal, .bottom], 8)
                }
            }
            // gradient for hls broadcasters
            .background ( !isHLSViewer ? overlayChatGradient : nil )
            .padding(tabPageBarState.wrappedValue == .visible ? [.bottom] : [], keyboardState.wrappedValue == .hidden ? 32 : 0)
            
            // Control panel
            if keyboardState.wrappedValue == .hidden {
                if isHLSViewer {
                    HMSBottomControlStrip(isChatPresented: $isChatPresented)
                        .padding(tabPageBarState.wrappedValue == .hidden ? [.horizontal, .top] : [.horizontal], 16)
                        .transition(.move(edge: .bottom))
                        .frame(height: controlsState.wrappedValue == .hidden ? 0 : nil)
                        .opacity(controlsState.wrappedValue == .hidden ? 0 : 1)
                    //                                        .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
                }
                else {
                    // dummy Hidden strip on webrtc for providing the correct height for overlay chat for hls broadcasters
                    HMSBottomControlStrip(isChatPresented: $isChatPresented)
                        .padding(tabPageBarState.wrappedValue == .hidden ? [.horizontal, .top] : [.horizontal], 16)
                        .transition(.move(edge: .bottom))
                        .frame(height: controlsState.wrappedValue == .hidden ? 0 : nil)
                        .opacity(0)
                }
            }
        }
        .background (
            // gradient for hls viewers
            isHLSViewer ? overlayChatGradient.edgesIgnoringSafeArea(.all) : nil
        )
    }
    
    var overlayChatGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.black.opacity(0.64), .black.opacity(0.0)]),
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

struct HMSChatOverlay_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        let roomKitModel: HMSRoomKitModel = {
            let model = HMSRoomKitModel()
            model.notifications.append(.init(id: "id1", type: .raiseHand, actorName: "Pawan", title: "Peer1 raised hands Peer1 raised hands", isDismissable: true))
            model.notifications.append(.init(id: "id2", type: .raiseHand, actorName: "Dmitry", isDismissed: true, title: "Peer2", isDismissable: true))
            model.notifications.append(.init(id: "id3", type: .raiseHand, actorName: "Praveen", title: "Peer3 raised hands", isDismissable: true))
            model.notifications.append(.init(id: "id4", type: .raiseHand, actorName: "Bajaj", title: "Peer4 raised hands", isDismissable: true))
            return model
        }()
        
        @State var isChatPresented = true
        
        HMSChatOverlay(isChatPresented: $isChatPresented, isHLSViewer: false, isChatOverlay: true)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2, [.prominent, .prominent]))
            .environmentObject(roomKitModel)
#endif
    }
}
