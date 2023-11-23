//
//  HMSNewMessagesButton.swift
//  HMSRoomKit
//
//  Created by Dmitry Fedoseyev on 16.08.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSNewMessagesButton: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("New messages")
                .font(.captionSemibold12)
                .foreground(.onSecondaryHigh)
                .padding(.horizontal, 8)
            Image(assetName: "chevron-down-large")
                .foreground(.onSecondaryHigh)
        }
        .padding(8)
        .background(.secondaryDefault, cornerRadius: 20)
    }
}

struct HMSNewMessagesButton_Previews: PreviewProvider {
    static var previews: some View {
        HMSNewMessagesButton().background(.black).environmentObject(HMSUITheme())
    }
}
