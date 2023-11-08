//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSOptionsToggleView: View {
    
    @Environment(\.pollsOptionAppearance) var pollsOptionAppearance
    
    var body: some View {
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
    }
}

struct HMSOptionsToggleView_Previews: PreviewProvider {
    static var previews: some View {
        HMSOptionsToggleView()
            .environmentObject(HMSUITheme())
    }
}
