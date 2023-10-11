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

struct HMSInsetTile: View {
    
    @ObservedObject var peerModel: HMSPeerModel
    @State var isOverlayHidden = false
    
    var body: some View {
        HMSPeerTile(peerModel: peerModel)
            .environment(\.peerTileAppearance, .constant(.init(.compact, isOverlayHidden: isOverlayHidden)))
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isOverlayHidden = true
                }
            }
            .background(.white.opacity(0.0001))
            .onTapGesture {
                isOverlayHidden.toggle()
                
                if !isOverlayHidden {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isOverlayHidden = true
                    }
                }
            }
    }
}

struct HMSInsetTile_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSInsetTile(peerModel: HMSPeerModel())
            .environmentObject(HMSUITheme())
            .environmentObject(HMSPeerModel())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
