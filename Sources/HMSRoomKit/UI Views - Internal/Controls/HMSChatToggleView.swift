//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSChatToggleView: View {
    
    var body: some View {
        Image(assetName: "chat-icon")
            .frame(width: 40, height: 40)
    }
}

struct HMSChatToggleView_Previews: PreviewProvider {
    static var previews: some View {
        HMSChatToggleView()
            .environmentObject(HMSUITheme())
    }
}
