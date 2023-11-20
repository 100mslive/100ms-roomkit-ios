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
            ZStack {
                if messages.isEmpty {
                    HMSChatPlaceholderView()
                }
                HMSChatListView()
            }
            
            if let pinnedMessage = roomModel.pinnedMessage, !pinnedMessage.isEmpty {
                HMSPinnedChatMessageView(text: pinnedMessage, isPartOfTransparentChat: false) {
                    roomModel.pinnedMessage = ""
                }
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
