//
//  HMSChatView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 07/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSChatScreen: View {
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @State var recipient: HMSRecipient = .everyone
    
    var body: some View {
        
        let messages =  roomModel.messages
        
        VStack(alignment: .leading, spacing: 16) {
            
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
            
            ZStack {
                if messages.isEmpty {
                    HMSChatPlaceholderView()
                }
                HMSChatListView(recipient: $recipient)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("To")
                        .foreground(.onSurfaceMedium)
                        .font(.captionRegular12)
                    HMSRolePicker(recipient: $recipient)
                    
//                    Image(systemName: "magnifyingglass")
//                        .resizable()
//                        .frame(width: 16, height: 16)
//                        .foreground(.onSurfaceMedium)
                }
                HMSSendChatField(recipient: recipient)
                    .background(.surfaceDefault, cornerRadius: 8)
            }
            .padding(.bottom, 16)
            
        }
        .padding(.horizontal, 16)
        .background(.surfaceDim, cornerRadius: 0, ignoringEdges: .all)
    }
}

struct HMSChatView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSChatScreen()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
