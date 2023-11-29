//
//  HMSChatListView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSChatListView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    private let messageCoordinateSpace = "messageCoordinateSpace"
    @State private var showNewMessageButton: Bool = false
    
    @Binding var recipient: HMSRecipient?
    var isTransparentMode = false

    var body: some View {
        
        if isTransparentMode {
            VStack {
                messageListView
                pinnedMessageView
            }
        }
        else {
            VStack {
                pinnedMessageView
                messageListView
            }
        }
    }
    
    @ViewBuilder
    var pinnedMessageView: some View {
        if roomModel.pinnedMessages.count > 0 {
            
            VStack {
                if roomModel.pinnedMessages.count < 2, let firstMessage = roomModel.pinnedMessages.first {
                    HMSPinnedChatMessageView(pinnedMessage:firstMessage, isPartOfTransparentChat: true) {
                        roomModel.pinnedMessages.remove(firstMessage)
                    }
                }
                else {
                    GeometryReader { proxy in
                        TabView {
                            ForEach(roomModel.pinnedMessages.suffix(3).reversed(), id:\.self) { message in
                                HMSPinnedChatMessageView(pinnedMessage: message, isPartOfTransparentChat: true) {
                                    roomModel.pinnedMessages.remove(message)
                                }
                                .padding(.leading, 30)
                            }
                            .rotationEffect(.degrees(-90)) // Rotate content
                            .frame(
                                width: proxy.size.width,
                                height: proxy.size.height
                            )
                        }
                        .frame(
                            width: 60, // Height & width swap
                            height: proxy.size.width
                        )
                        .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
                        .offset(x: proxy.size.width) // Offset back into screens bounds
                        .tabViewStyle(
                            PageTabViewStyle(indexDisplayMode: .always)
                        )
                    }
                    .frame(height: 60)
                }
            }
            .background(.surfaceDefault, cornerRadius: 8)
        }
    }
    
    @ViewBuilder
    var messageListView: some View {
        
        let messages = roomModel.messages
        
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                GeometryReader { proxy in
                    let frame = proxy.frame(in: .named(messageCoordinateSpace))
                    let offset = frame.minY
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: offset)
                }
                LazyVStack(spacing: 0) {
                    
                    let filteredMessages = messages.filter({ message in
#if Preview
                        return true
#else
                        // Don't show service messages
                        guard let sender = message.sender else { return false }
                        
                        // Don't show messages from blacklisted user ids
                        if let customerUserID = sender.customerUserID, roomModel.chatPeerBlacklist.contains(customerUserID) {
                            return false
                        }
                        
                        // Don't show hidden messages
                        guard !roomModel.chatMessageBlacklist.contains(message.messageID) else { return false }
                        
                        if let recipient {
                            switch recipient {
                            case .everyone:
                                return message.recipient.type == .broadcast
                            case .peer(let peer):
                                
                                guard let peer, message.recipient.type == .peer else { return false }
                                return message.recipient.peerRecipient == peer.peer
                                
                            case .role(let role):
                                guard message.recipient.type == .roles else { return false }
                                return message.recipient.rolesRecipient?.contains(role) ?? false
                            }
                        }
                        else {
                            // if we don't have recipient then show public messages
                            return message.recipient.type == .broadcast
                        }
#endif
                    })
                    
                    ForEach(filteredMessages.reversed(), id:\.self) { message in
                        HMSChatMessageView(messageModel: message, isPartOfTransparentChat: isTransparentMode, recipient: $recipient)
                            .id(message.messageID)
                            .mirrorV()
                    }
                }
            }
            .overlay(alignment: .top) {
                if showNewMessageButton {
                    HMSNewMessagesButton().onTapGesture {
                        if let lastId = messages.first?.messageID {
                            withAnimation {
                                scrollView.scrollTo(lastId, anchor: nil)
                            }
                        }
                    }.mirrorV()
                }
            }
            .coordinateSpace(name: messageCoordinateSpace)
            .mirrorV()
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                DispatchQueue.main.async {
                    let newOffset = offset ?? 0
                    showNewMessageButton = newOffset < -20
                }
            }
            .onChange(of: messages) { messages in
                if let lastId = messages.first?.messageID {
                    withAnimation {
                        scrollView.scrollTo(lastId, anchor: nil)
                    }
                }
            }.onAppear() {
                if let lastId = messages.first?.messageID {
                    withAnimation {
                        scrollView.scrollTo(lastId, anchor: nil)
                    }
                }
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}


struct HMSChatListView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSChatListView(recipient: .constant(.everyone))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
