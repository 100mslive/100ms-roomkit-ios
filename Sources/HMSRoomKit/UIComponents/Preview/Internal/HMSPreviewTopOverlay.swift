//
//  HMSPreviewTopOverlay.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 21/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSPreviewTopOverlay: View {
    
    @Environment(\.previewParams) var previewComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            HMSCompanyLogoView()
            
            VStack(spacing: 4) {
                Text(previewComponentParam.title)
                    .font(.heading5Semibold24)
                    .foreground(.onSurfaceHigh)
                
                Text(previewComponentParam.subTitle)
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
            }
            
            HStack(spacing: 8) {
                if roomModel.isBeingStreamed == true {
                    HMSLiveLabel()
                        .background(.errorDefault, cornerRadius: 20)
                }
                
                if let peerCount = roomModel.peerCount {
                    HMSParticipantsPreviewLabel(peerCount: peerCount)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct HMSPreviewTopOverlay_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPreviewTopOverlay()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
