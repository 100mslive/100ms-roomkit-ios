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

public struct HMSChatScreen<Content, ContentV>: View where Content : View, ContentV: View {
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @State private var recipient: HMSRecipient?
    var isTransparentMode: Bool = false
    
    @ViewBuilder let content: () -> Content
    @ViewBuilder let contentV: () -> ContentV
    public init(isTransparentMode: Bool = false, @ViewBuilder content: @escaping () -> Content, @ViewBuilder contentV: @escaping () -> ContentV) {
        self.content = content
        self.contentV = contentV
        self.isTransparentMode = isTransparentMode
    }
    
    public var body: some View {
        
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
            
            if let chatScopes {
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
                            recipient = nil
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
        
        let chatScopes = conferenceParams.chat?.chatScopes ?? []
        
        if chatScopes.count > 0 {
            
            VStack {
                
                contentV()
                
                if let localPeerModel = roomModel.localPeerModel {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            Text("To")
                                .foreground(.onSurfaceMedium)
                                .font(.captionRegular12)
                            HMSRolePicker(recipient: $recipient)
                        }
                        
                        if let customerUserId = localPeerModel.customerUserId, roomModel.chatPeerBlacklist.contains(customerUserId) {
                            // if user is blacklisted don't show send field
                            
                            HStack {
                                Spacer()
                                Text("You’ve been blocked from sending messages")
                                    .foreground(.onSurfaceMedium)
                                    .font(.body2Regular14)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(.surfaceDefault, cornerRadius: 8)
                        }
                        else {
                            if let recipient {
                                HStack {
                                    HMSSendChatField(recipient: recipient)
                                        .background(.surfaceDefault, cornerRadius: 8)
                                    
                                    content()
                                }
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
            HMSChatScreen(content: {}, contentV: {})
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
            
            HMSChatScreen(isTransparentMode: true, content: {}, contentV: {})
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
            
        }
#endif
    }
}
