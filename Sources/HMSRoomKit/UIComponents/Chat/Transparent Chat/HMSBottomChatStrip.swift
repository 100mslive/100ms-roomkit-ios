//
//  HMSBottomChatStrip.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

struct HMSBottomChatStrip: View {
    
    @State var recipient: HMSRecipient = .everyone

    var body: some View {
        HStack {
            HMSSendChatField(recipient: recipient)
            .frame(height: 40)
            .background(.surfaceDefault, cornerRadius: 8)
        }
    }
}

struct HMSBottomChatStrip_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSBottomChatStrip()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
