//
//  HMSOverlayChatView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSTransparentChatScreen: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @State var recipient: HMSRecipient?
    
    var isTransparentMode = true
    
    var body: some View {
        
        HMSChatScreen(isTransparentMode: true)
        
//        VStack {
//            
//            HMSChatListView(recipient: $recipient, isTransparentMode: isTransparentMode)
//                        
//            HMSBottomChatStrip()
//                .onTapGesture {
//                    // to make sure it does not trigger controls hide action
//                }
//        }
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
