//
//  HMSLiveLabel.swift
//  HMSSDK
//
//  Created by Dmitry Fedoseyev on 21.07.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSLiveLabel: View {
    
    var showsCircle = true
    
    var body: some View {
        HStack(spacing: 7) {
            if showsCircle {
                Circle()
                    .frame(width: 13, height: 13)
                    .foreground(.errorBrighter)
            }
            Text("LIVE")
                .font(.body2Semibold14)
                .foreground(.errorBrighter)
        }
        .padding(12)
        
    }
}

struct HMSLiveLabel_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSLiveLabel()
            .environmentObject(HMSUITheme())
#endif
    }
}
