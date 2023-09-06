//
//  HMSChatListView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSChatListView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    private let messageCoordinateSpace = "messageCoordinateSpace"
    @State private var showNewMessageButton: Bool = false
    
    var isTransparentMode = false

    var body: some View {
        #if !Preview
        let messages = roomModel.messages.reversed().map { HMSMessageModel(message: $0) }
        #else
        let messages = roomModel.messages
        #endif
        
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                GeometryReader { proxy in
                    let frame = proxy.frame(in: .named(messageCoordinateSpace))
                    let offset = frame.minY
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: offset)
                }
                LazyVStack(spacing: 0) {
                    ForEach(messages) { message in
                        HMSChatMessageView(messageModel: message, isPartOfTransparentChat: isTransparentMode).id(message.id).mirrorV()
                    }
                }
            }
            .overlay(alignment: .top) {
                if showNewMessageButton {
                    HMSNewMessagesButton().onTapGesture {
                        if let lastId = messages.first?.id {
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
                if let lastId = messages.first?.id {
                    withAnimation {
                        scrollView.scrollTo(lastId, anchor: nil)
                    }
                }
            }.onAppear() {
                if let lastId = messages.first?.id {
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
        HMSChatListView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
