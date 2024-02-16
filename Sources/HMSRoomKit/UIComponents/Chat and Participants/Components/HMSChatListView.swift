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
    
    @Environment(\.keyboardState) var keyboardState
    
    @Environment(\.chatScreenAppearance) var chatScreenAppearance
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @State private var showNewMessageButton: Bool = false
    
    @Binding var recipient: HMSRecipient?
    
    @State var selectedPinnedMessage: HMSRoomModel.PinnedMessage?
    
    var body: some View {
        
        if chatScreenAppearance.pinnedMessagePosition.wrappedValue == .bottom {
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
    
    @State var isPinnedViewExpanded = false
    
    @ViewBuilder
    var pinnedMessageView: some View {
        
        let isTransparentMode = chatScreenAppearance.mode.wrappedValue == .transparent
        
        let canPinMessages =  conferenceParams.chat?.allowsPinningMessages ?? false
        let filteredPinnedMessages = roomModel.pinnedMessages.filter{pinnedMessage in !roomModel.chatMessageBlacklist.contains{$0 == pinnedMessage.id}}.suffix(3).reversed()
        
        if filteredPinnedMessages.count > 0 {
            
            VStack {
                if filteredPinnedMessages.count < 2, let firstMessage = filteredPinnedMessages.first {
                    
                    HStack {
                        HMSPinnedChatMessageView(pinnedMessage:firstMessage, isPartOfTransparentChat: isTransparentMode)
                            .lineLimit(isPinnedViewExpanded ? nil : 2)
                            .background(.white.opacity(0.0001))
                            .onTapGesture {
                                withAnimation {
                                    isPinnedViewExpanded.toggle()
                                    //scrollProxy?.scrollTo(firstMessage.id, anchor: nil)
                                }
                            }
                        
                        if canPinMessages {
                            Image(assetName: "unpin")
                                .foreground(.onSurfaceMedium)
                                .onTapGesture {
                                    roomModel.pinnedMessages.removeAll{$0 == firstMessage}
                                }
                        }
                    }
                    .padding(8)
                    .background {
                        if !isTransparentMode {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .background(.surfaceDefault, cornerRadius: 8)
                                .padding(.trailing, canPinMessages ? 35 : 0)
                                .background(.surfaceDim, cornerRadius: 8)
                        }
                        else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .background(.black, cornerRadius: 8, opacity: 0.64)
                        }
                    }
                }
                else {
                    HStack {
                        
                        ZStack {
                            
                            GeometryReader { proxy in
                                
                                TabView(selection: $selectedPinnedMessage) {
                                    
                                    ForEach(filteredPinnedMessages, id:\.self) { message in
                                        HMSPinnedChatMessageView(pinnedMessage: message, isPartOfTransparentChat: isTransparentMode)
                                            .background(.white.opacity(0.0001))
                                            .lineLimit(isPinnedViewExpanded ? nil : 2)
                                            .onTapGesture {
                                                withAnimation {
                                                    isPinnedViewExpanded.toggle()
                                                    //scrollProxy?.scrollTo(message.id, anchor: nil)
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
                                    selectedPinnedMessage = filteredPinnedMessages.first
                                }
                                .frame(
                                    width: filteredPinnedMessages.count == 2 ? 30 : 45, // Height & width swap
                                    height: proxy.size.width
                                )
                                .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
                                .offset(x: proxy.size.width) // Offset back into screens bounds
                                .tabViewStyle(
                                    PageTabViewStyle(indexDisplayMode: .always)
                                )
                            }
                            .padding(.leading, -20)
                            .frame(height: (filteredPinnedMessages.count == 2) ? 30 : 45)
                            .clipped()
                            .opacity(isPinnedViewExpanded ? 0 : 1.0)
                            
                            if isPinnedViewExpanded {
                                if let selectedPinnedMessage = selectedPinnedMessage {
                                    HMSPinnedChatMessageView(pinnedMessage: selectedPinnedMessage, isPartOfTransparentChat: isTransparentMode)
                                        .background(.white.opacity(0.0001))
                                        .lineLimit(nil)
                                        .onTapGesture {
                                            withAnimation {
                                                isPinnedViewExpanded.toggle()
                                                //scrollProxy?.scrollTo(message.id, anchor: nil)
                                            }
                                        }
                                }
                            }
                            else {
                                
                            }
                        }
                        
                        if canPinMessages {
                            Image(assetName: "unpin")
                                .foreground(.onSurfaceMedium)
                                .onTapGesture {
                                    
                                    if let message = selectedPinnedMessage {
                                        roomModel.pinnedMessages.removeAll{$0 == message}
                                    }
                                    
                                }
                        }
                    }
                    .padding(8)
                    .background {
                        if !isTransparentMode {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .background(.surfaceDefault, cornerRadius: 8)
                                .padding(.trailing, canPinMessages ? 35 : 0)
                                .background(.surfaceDim, cornerRadius: 8)
                        }
                        else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .background(.black, cornerRadius: 8, opacity: 0.64)
                        }
                    }
                }
            }
        }
    }
    
    @State var isLastMessageVisible = false
    
    @ViewBuilder
    var messageListView: some View {
        
        let isTransparentMode = chatScreenAppearance.mode.wrappedValue == .transparent
        
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
        
        let messages = roomModel.messages
        
        ScrollViewReader { scrollViewProxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: isTransparentMode ? 12 : 5) {
                    
                    let filteredMessages = messages.filter({ message in
#if Preview
                        return true
#else
                        // Don't show service messages
                        guard message.sender != nil else { return false }
                        
                        // Don't show hidden messages
                        guard !roomModel.chatMessageBlacklist.contains(message.messageID) else { return false }
                        
                        return true
#endif
                    })
                    
                    ForEach(filteredMessages, id:\.self) { message in
                        HMSChatMessageView(messageModel: message, recipient: $recipient)
                            .id(message.messageID)
                            .onAppear() {
                                if message == messages.last {
                                    showNewMessageButton = false
                                    isLastMessageVisible = true
                                }
                            }
                            .onDisappear() {
                                if message == messages.last {
                                    isLastMessageVisible = false
                                }
                            }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if showNewMessageButton {
                    HMSNewMessagesButton()
                        .onTapGesture {
                            scrollToBottom(scrollViewProxy: scrollViewProxy)
                        }
                }
            }
            .onChange(of: messages) { messages in
                if isLastMessageVisible || keyboardState.wrappedValue == .visible {
                    scrollToBottom(scrollViewProxy: scrollViewProxy)
                } else {
                    showNewMessageButton = true
                }
            }
            .onAppear() {
                scrollToBottom(scrollViewProxy: scrollViewProxy, animate: false)
            }
            .onChange(of: keyboardState.wrappedValue) { keyboardState in
                if keyboardState == .visible || isLastMessageVisible {
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        scrollToBottom(scrollViewProxy: scrollViewProxy, animate: keyboardState == .visible)
                    }
                }
            }
        }
    }
    
    func scrollToBottom(scrollViewProxy: ScrollViewProxy, animate: Bool = true) {
        
        let messages = roomModel.messages
        
        if let lastId = messages.last?.messageID {
            if animate {
                withAnimation {
                    scrollViewProxy.scrollTo(lastId, anchor: .top)
                }
            }
            else {
                scrollViewProxy.scrollTo(lastId, anchor: .top)
            }
        }
    }
}

struct HMSChatListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
#if Preview
            HMSChatListView(recipient: .constant(.everyone))
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
            
#if Preview
            HMSChatListView(recipient: .constant(.everyone))
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(4))
                .environment(\.chatScreenAppearance, .constant(.init(mode: .plain)))
#endif
        }
    }
}
