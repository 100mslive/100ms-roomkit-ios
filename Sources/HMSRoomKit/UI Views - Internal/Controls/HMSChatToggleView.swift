//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSChatToggleView: View {
    
    @Environment(\.chatBadgeState) var chatBadgeState
    
    var body: some View {
        Image(assetName: "chat-icon")
            .resizable()
            .frame(width: 16, height: 16)
            .overlay(alignment: .topTrailing, content: {
                if chatBadgeState.wrappedValue == .badged {
                    Image(assetName: "chat-badge-icon")
                        .resizable()
                        .frame(width: 8, height: 8)
                        .foreground(.primaryDefault)
                        .padding(-2)
                }
            })
            .frame(width: 24, height: 24)
            .frame(width: 40, height: 40)
    }
}

struct HMSChatToggleView_Previews: PreviewProvider {
    static var previews: some View {
        HMSChatToggleView()
            .environmentObject(HMSUITheme())
            .environment(\.chatBadgeState, .constant(.badged))
    }
}
