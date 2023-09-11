//
//  HMSOverlayChatView.swift
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

struct HMSTransparentChatScreen: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @State var recipient: HMSRecipient = .everyone
    
    var isTransparentMode = false
    
    var body: some View {
        VStack {
            HMSChatListView(isTransparentMode: isTransparentMode)
            
            if let pinnedMessage = roomModel.pinnedMessage, !pinnedMessage.isEmpty {
                HMSPinnedChatMessageView(text: pinnedMessage, isPartOfTransparentChat: true) {
                    roomModel.pinnedMessage = ""
                }
            }
                        
            HMSBottomChatStrip()
                .onTapGesture {
                    // to make sure it does not trigger controls hide action
                }
        }
    }
}

struct HMSTransparentChatScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSTransparentChatScreen()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
