//
//  HMSPinnedChatMessageView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels

struct HMSPinnedChatMessageView: View {
    
    let pinnedMessage: HMSRoomModel.PinnedMessage
    var isPartOfTransparentChat: Bool
    var onUnpin: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            
            Image(systemName: "pin")
                .foreground(.onSurfaceMedium)
            
            Text(pinnedMessage.text)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .font(.captionSemibold12)
                .foreground(isPartOfTransparentChat ? .white : .onSurfaceHigh)
                .shadow(color: isPartOfTransparentChat ? .black : .clear, radius: 3, y: 1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                onUnpin()
            } label: {
                Image(systemName: "xmark")
            }
            .foreground(.onSurfaceMedium)
        }
        .padding(8)
        .cornerRadius(8)
    }
}

struct HMSPinnedChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        HMSPinnedChatMessageView(pinnedMessage: .init(text: "This is pinned message, This is pinned message, This is pinned message, This is pinned message, This is pinned message, This is pinned message, This is pinned message, This is pinned message, This is pinned message, This is pinned message", id: "1", pinnedBy: "dummy user"), isPartOfTransparentChat: true) {}
            .environmentObject(HMSUITheme())
    }
}
