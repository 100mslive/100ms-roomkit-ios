//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSEndCallButtonView: View {
    enum ButtonType {
        case webrtc
        case hls
    }
    var type: ButtonType
    
    var iconName: String {
        switch type {
        case .webrtc:
            return "hangup"
        case .hls:
            return "xmark"
        }
    }
    
    var body: some View {
        Image(assetName: iconName)
            .foreground(type == .hls ? .white : .onPrimaryHigh)
            .frame(width: type == .hls ? 32 : 40, height: type == .hls ? 32 : 40)
            .background(type == .hls ? .clear : .errorDefault, cornerRadius: 8)
    }
}

struct HMSEndCallButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HMSEndCallButtonView(type: .webrtc)
                .environmentObject(HMSUITheme())
            HMSEndCallButtonView(type: .hls)
                .environmentObject(HMSUITheme())
        }
        
    }
}
