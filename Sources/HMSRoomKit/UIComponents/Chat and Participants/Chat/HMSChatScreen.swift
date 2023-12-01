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
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @State var recipient: HMSRecipient?
    var isTransparentMode: Bool = false
    
    var body: some View {
        
        Group {
            if isTransparentMode {
                chatView
            }
            else {
                chatView
                    .padding(.horizontal, 16)
                    .background(.surfaceDim, cornerRadius: 0, ignoringEdges: .all)
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    var chatView: some View {
        
        let chatScopes = conferenceParams.chat?.chatScopes
        
        var allowedRoles: [HMSRole] {
            
            if let chatScopes = chatScopes {
                if let roleScope = chatScopes.first(where: { scope in
                    switch scope {
                    case .roles(_):
                        return true
                    default:
                        return false
                    }
                }) {
                    if case let .roles(whiteList: whiteListedRoles) = roleScope {
                        return roomModel.roles.filter{whiteListedRoles.contains($0.name)}
                    }
                }
            }
            
            // by default no roles are allowed
            return []
        }
        
        return VStack(alignment: .leading, spacing: 16) {
            
            chatListView
            
            if let chatScopes {
                sendMessageView
                    .onAppear() {
                        if chatScopes.contains(.public) {
                            recipient = .everyone
                        }
                        else if let firstWhiteListedRole = allowedRoles.first {
                            recipient = .role(firstWhiteListedRole)
                        }
                        else {
                            recipient = .everyone
                        }
                    }
            }
        }
    }
    
    var chatListView: some View {
        
        let messages =  roomModel.messages
        
        return ZStack {
            if !isTransparentMode {
                if messages.isEmpty {
                    HMSChatPlaceholderView()
                }
            }
            HMSChatListView(recipient: $recipient, isTransparentMode: isTransparentMode)
        }
    }
    
    @ViewBuilder
    var sendMessageView: some View {
        
        if let chatScopes = conferenceParams.chat?.chatScopes {
            
            VStack {
                if let recipient, let localPeerModel = roomModel.localPeerModel {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            Text("To")
                                .foreground(.onSurfaceMedium)
                                .font(.captionRegular12)
                            HMSRolePicker(recipient: Binding(get: {
                                recipient
                            }, set: {
                                self.recipient = $0
                            }))
                        }
                        
                        if let customerUserId = localPeerModel.customerUserId, roomModel.chatPeerBlacklist.contains(customerUserId) {
                            // if user is blacklisted don't show send field
                        }
                        else {
                            if recipient == .everyone && !chatScopes.contains(.public) {
                                // if everyone is selected but we don't have public chat scope, don't show send field
                            }
                            else {
                                HMSSendChatField(recipient: recipient)
                                    .background(.surfaceDefault, cornerRadius: 8)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

struct HMSChatView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        VStack {
            HMSChatScreen()
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
            
            HMSChatScreen(isTransparentMode: true)
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
            
        }
#endif
    }
}
