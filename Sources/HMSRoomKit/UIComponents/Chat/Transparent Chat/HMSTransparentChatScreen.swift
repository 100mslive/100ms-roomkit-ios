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
    @State var recipient: HMSRecipient = .everyone
    
    var isTransparentMode = false
    
    var body: some View {
        VStack {
            
            if roomModel.pinnedMessages.count > 0 {
                GeometryReader { proxy in
                    TabView {
                        ForEach(roomModel.pinnedMessages.suffix(3), id:\.self) { message in
                            HMSPinnedChatMessageView(text: message, isPartOfTransparentChat: false) {
                                roomModel.pinnedMessages.removeAll{$0 == message}
                            }
                        }
                        .rotationEffect(.degrees(-90)) // Rotate content
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height
                        )
                    }
                    .frame(
                        width: proxy.size.height, // Height & width swap
                        height: proxy.size.width
                    )
                    .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
                    .offset(x: proxy.size.width) // Offset back into screens bounds
                    .tabViewStyle(
                        PageTabViewStyle(indexDisplayMode: .never)
                    )
                }
            }
            
            HMSChatListView(recipient: $recipient, isTransparentMode: isTransparentMode)
                        
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
