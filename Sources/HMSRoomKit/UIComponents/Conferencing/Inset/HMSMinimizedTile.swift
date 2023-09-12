//
//  HMSMinimizedTile.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 09/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSMinimizedInsetTile: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @Binding var isInsetMinimized: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            
            HStack(spacing: 6) {
                if roomModel.localAudioTrackModel != nil {
                    HMSMicToggleView(isMute: roomModel.isMicMute)
                        .frame(width: 16, height: 16)
                        .frame(width: 20, height: 20)
                        .background(.surfaceBright, cornerRadius: 4)
                }
                
                if roomModel.localVideoTrackModel != nil {
                    HMSCameraToggleView(isMute: roomModel.isCameraMute)
                        .frame(width: 16, height: 16)
                        .frame(width: 20, height: 20)
                        .background(.surfaceBright, cornerRadius: 4)
                }
                
                Text("You")
                    .font(.body2Regular14)
            }

            HMSExpandIconView()
                .frame(width: 14, height: 14)
                
        }
        .foreground(.onSurfaceHigh)
        .padding(8)
        .background(.surfaceDefault, cornerRadius: 8)
        .onTapGesture {
            isInsetMinimized = false
        }
    }
}

struct HMSMinimizedLocalTile_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSMinimizedInsetTile(isInsetMinimized: .constant(false))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}

