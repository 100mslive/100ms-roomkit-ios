//
//  HMSChatPlaceholderView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSChatPlaceholderView: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(assetName: "chat-placeholder")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .minimumScaleFactor(0.5)
            Text("Start a conversation")
                .font(.heading6Semibold20)
                .foreground(.onSurfaceHigh)
            Text("There are no messages here yet. Start a conversation by sending a message.")
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .font(.body2Regular14)
                .foreground(.onSurfaceMedium)
        }
    }
}

struct HMSChatPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        HMSChatPlaceholderView()
            .environmentObject(HMSUITheme())
    }
}
