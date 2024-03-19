//
//  HMSMicButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSParticipantNameLabelView: View {
    
    let name: String?
    let wifiStrength: Int
    let isSIP: Bool

    var body: some View {
        HStack(spacing: 5) {
            if isSIP {
                Image(assetName: "phone", renderingMode: .original)
            }
            
            if let name = name {
                Text("\(name)")
                    .kerning(0.25)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
            
            // show 1,2,3 - 4 is good, 0 is unknown
            if wifiStrength > 0 && wifiStrength < 4 {
                HMSWifiSignalView(level: wifiStrength)
            }
        }
        .font(.body2Regular14)
        .foreground(.onSurfaceHigh)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.backgroundDim, cornerRadius: 8, opacity: 0.8)
    }
}

struct HMSParticipantNameView_Previews: PreviewProvider {
    static var previews: some View {
        
        Rectangle()
            .overlay(alignment: .bottom) {
                HStack {
                    HMSParticipantNameLabelView(name: "Pawans iOS eddsds sds sdds", wifiStrength: 4, isSIP: false)
                        .border(.yellow)
                    
                    Spacer()
                }
            }
            .frame(width: 250, height: 300)
        
            .environmentObject(HMSUITheme())
    }
}

