//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSSwitchCameraButtonView: View {
    
    let isEnabled: Bool
    
    var body: some View {
        Image(assetName: "switch-camera-icon")
            .foreground(isEnabled ? .onSurfaceHigh : .onSurfaceLow)
            .frame(width: 40, height: 40)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1.0)
                    .foreground(.borderBright)
            }
            
    }
}

struct HMSSwitchCameraButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HMSSwitchCameraButtonView(isEnabled: false)
            .environmentObject(HMSUITheme())
    }
}
