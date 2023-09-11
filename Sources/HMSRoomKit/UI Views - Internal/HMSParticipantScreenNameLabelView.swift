//
//  HMSMicButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSParticipantScreenNameLabelView: View {
    
    let name: String
    
    var body: some View {
        if name.count > 0 {
            HStack {
                Image(assetName: "screenshare-icon")
                Text("\(name)'s Screen")
            }
            .font(.body2Regular14)
            .foreground(.onSurfaceHigh)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.backgroundDim, cornerRadius: 8, opacity: 0.8)
        }
    }
}

struct HMSParticipantScreenNameLabelView_Previews: PreviewProvider {
    static var previews: some View {
        HMSParticipantScreenNameLabelView(name: "Pawan's iOS")
            .environmentObject(HMSUITheme())
    }
}

