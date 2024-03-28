//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels

struct HMSOptionsToggleView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    let isHLSViewer: Bool
    
    @Environment(\.pollsOptionAppearance) var pollsOptionAppearance
    @Environment(\.menuContext) var menuContext
    
    @State var isSessionMenuPresented = false
    
    var body: some View {
        if let localPeerModel = roomModel.localPeerModel {
            Image(assetName: "hamburger")
                .frame(width: 40, height: 40)
                .controlAppearance(isEnabled: true)
                .overlay(alignment: .topTrailing, content: {
                    if pollsOptionAppearance.badgeState.wrappedValue == .badged {
                        Image(assetName: "chat-badge-icon")
                            .resizable()
                            .frame(width: 8, height: 8)
                            .foreground(.primaryDefault)
                            .padding(-2)
                    }
                })
                .onTapGesture {
                    isSessionMenuPresented.toggle()
                }
                .sheet(isPresented: $isSessionMenuPresented, onDismiss: {
                    menuContext.wrappedValue = .none
                }) {
                    HMSSheet {
                        Group {
                            if verticalSizeClass == .regular {
                                HMSOptionSheetView(isHLSViewer: isHLSViewer)
                            }
                            else {
                                ScrollView {
                                    HMSOptionSheetView(isHLSViewer: isHLSViewer)
                                }
                            }
                        }
                        .environmentObject(currentTheme)
                        .environmentObject(roomModel)
                        .environmentObject(localPeerModel)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                .onChange(of: roomModel.peersSharingScreen) { peersSharingScreen in
                    if peersSharingScreen.count > 0 {
                        if roomModel.whiteboard != nil {
                            Task {
                                try await roomModel.stopWhiteboard()
                            }
                        }
                    }
                }
        }
    }
}

struct HMSOptionsToggleView_Previews: PreviewProvider {
    static var previews: some View {
        #if Preview
        HMSOptionsToggleView(isHLSViewer: true)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
        #endif
    }
}
