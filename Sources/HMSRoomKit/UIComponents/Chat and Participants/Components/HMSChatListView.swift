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
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var roomModel: HMSRoomModel
    private let messageCoordinateSpace = "messageCoordinateSpace"
    @State private var showNewMessageButton: Bool = false
    
    @Binding var recipient: HMSRecipient?
    var isTransparentMode = false
    
    @State var scrollProxy: ScrollViewProxy?
    
    @State var selectedPinnedMessage: HMSRoomModel.PinnedMessage?
    
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
        
        let canPinMessages =  conferenceParams.chat?.allowsPinningMessages ?? false
        
        if roomModel.pinnedMessages.count > 0 {
            
            VStack {
                if roomModel.pinnedMessages.count < 2, let firstMessage = roomModel.pinnedMessages.first {
                    
                    HStack {
                        HMSPinnedChatMessageView(scrollProxy: scrollProxy, pinnedMessage:firstMessage, isPartOfTransparentChat: true)
                            .background(.white.opacity(0.0001))
                            .onTapGesture {
                                withAnimation {
                                    scrollProxy?.scrollTo(firstMessage.id, anchor: nil)
                                }
                            }
                        
                        Image(systemName: "pin")
                            .foreground(.onSurfaceHigh)
                            .onTapGesture {
                                if canPinMessages {
                                    roomModel.pinnedMessages.remove(firstMessage)
                                }
                            }
                    }
                    .padding(8)
                    .cornerRadius(8)
                }
                else {
                    HStack {
                        
                        let pinnedMessages = roomModel.pinnedMessages.suffix(3).reversed()
                        
                        GeometryReader { proxy in

                            TabView(selection: $selectedPinnedMessage) {
                                
                                ForEach(pinnedMessages, id:\.self) { message in
                                    HMSPinnedChatMessageView(scrollProxy: scrollProxy, pinnedMessage: message, isPartOfTransparentChat: true)
                                        .background(.white.opacity(0.0001))
                                        .onTapGesture {
                                            withAnimation {
                                                scrollProxy?.scrollTo(message.id, anchor: nil)
                                            }
                                        }
                                        .padding(.leading, 40)
                                        .tag(message as HMSRoomModel.PinnedMessage?)
                                }
                                .rotationEffect(.degrees(-90)) // Rotate content
                                .frame(
                                    width: proxy.size.width,
                                    height: proxy.size.height
                                )
                            }
                            .onAppear() {
                                selectedPinnedMessage = pinnedMessages.first
                            }
                            .frame(
                                width: pinnedMessages.count == 2 ? 30 : 45, // Height & width swap
                                height: proxy.size.width
                            )
                            .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
                            .offset(x: proxy.size.width) // Offset back into screens bounds
                            .tabViewStyle(
                                PageTabViewStyle(indexDisplayMode: .always)
                            )
                        }
                        .padding(.leading, -20)
                        .frame(height: (pinnedMessages.count == 2) ? 30 : 45)
                        .clipped()
                        
                        Image(systemName: "pin")
                            .foreground(.onSurfaceHigh)
                            .onTapGesture {
                                if canPinMessages {
                                    if let message = selectedPinnedMessage {
                                        roomModel.pinnedMessages.remove(message)
                                    }
                                }
                            }
                    }
                    .padding(8)
                    .cornerRadius(8)
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
                        if let lastId = messages.last?.messageID {
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
                if let lastId = messages.last?.messageID {
                    withAnimation {
                        scrollView.scrollTo(lastId, anchor: nil)
                    }
                }
            }
            .onAppear() {
                scrollProxy = scrollView
                if let lastId = messages.last?.messageID {
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