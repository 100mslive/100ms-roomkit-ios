//
//  HMSMicToggle.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSParticipantCountStatusView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        if let peerCount = roomModel.peerCount, peerCount > 0 {
            HStack(spacing: 4) {
                Image(assetName: "eye-icon")
                    .foreground(.onSurfaceHigh)
                Text("\(viewerCountString(count: peerCount))")
                    .font(.overlineMedium)
                    .foreground(.onSurfaceHigh)
            }
            .padding(.horizontal, 8)
            .frame(height: 24)
            .background(.backgroundDim, cornerRadius: 4, opacity: 0.64, border: .borderBright)
        }
    }
    
    func viewerCountString(count: Int) -> String {
        if count < 1000 {
            return "\(count)"
        } else {
            let countInK = Double(count) / 1000.0
            return String(format: "%.1f K", countInK)
        }
    }
}

struct HMSParticipantCountStatusView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSParticipantCountStatusView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(12500))
#endif
    }
}
