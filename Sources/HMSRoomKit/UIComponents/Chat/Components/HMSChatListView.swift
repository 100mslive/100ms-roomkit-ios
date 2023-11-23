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
    
    @Binding var recipient: HMSRecipient
    var isTransparentMode = false

    var body: some View {
        
        let messages = roomModel.messages
        
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                GeometryReader { proxy in
                    let frame = proxy.frame(in: .named(messageCoordinateSpace))
                    let offset = frame.minY
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: offset)
                }
                LazyVStack(spacing: 0) {
                    ForEach(messages.filter({ message in
                        #if !Preview
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
                        #else
                        return true
                        #endif
                    }), id:\.messageID) { message in
                        HMSChatMessageView(messageModel: message, isPartOfTransparentChat: isTransparentMode)
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
