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
    
    @Environment(\.chatScreenAppearance) var chatScreenAppearance
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.keyboardState) var keyboardState
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @State private var recipient: HMSRecipient?
    
    @ViewBuilder let content: () -> Content
    @ViewBuilder let contentV: () -> ContentV
    public init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder contentV: @escaping () -> ContentV) {
        self.content = content
        self.contentV = contentV
    }
    
    public var body: some View {
        
        let isTransparentMode = chatScreenAppearance.mode.wrappedValue == .transparent
        
        Group {
            if isTransparentMode {
                chatView
            }
            else {
                chatView
                    .padding(verticalSizeClass == .regular ? .horizontal : .leading, 16)
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
            
            sendMessageView
                .onAppear() {
                    if let chatScopes {
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
        
        let isTransparentMode = chatScreenAppearance.mode.wrappedValue == .transparent
        
        let chatScopes = conferenceParams.chat?.chatScopes
        let messages =  roomModel.messages
        
        return ZStack {
            if keyboardState.wrappedValue == .hidden && !isTransparentMode && (chatScopes?.count ?? 0) > 0 {
                if messages.isEmpty {
                    HMSChatPlaceholderView()
                        .padding()
                }
            }
            HMSChatListView(recipient: $recipient)
        }
    }
    
    @ViewBuilder
    var sendMessageView: some View {
        
        let chatScopes = conferenceParams.chat?.chatScopes ?? []
        
        if chatScopes.count > 0 {
            
            VStack {
                
                if keyboardState.wrappedValue == .hidden {
                    contentV()
                }
                
                if let localPeerModel = roomModel.localPeerModel {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        if !(chatScopes.count == 1 && chatScopes.contains(.public)) {
                            HStack {
                                Text("To")
                                    .foreground(.onSurfaceMedium)
                                    .font(.captionRegular12)
                                HMSRolePicker(recipient: $recipient)
                            }
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
                                    
                                    if keyboardState.wrappedValue == .hidden {
                                        content()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        else {
            VStack(spacing: 8) {
                
                if keyboardState.wrappedValue == .hidden {
                    contentV()
                }
                
                HStack(spacing: 8) {
                    HStack {
                        Spacer()
                        Text("Chat disabled.")
                            .foreground(.onSurfaceMedium)
                            .font(.body2Regular14)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(.surfaceDefault, cornerRadius: 8)
                    
                    if keyboardState.wrappedValue == .hidden {
                        content()
                    }
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
            
            HMSChatScreen(content: {}, contentV: {})
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
                .environment(\.chatScreenAppearance, .constant(.init(mode: .transparent)))
            
        }
#endif
    }
}
