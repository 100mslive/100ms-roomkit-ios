//
//  HMSLocalScreenShareView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 27/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSLocalScreenShareView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                
                Group {
                    Image(assetName: "screen-share-icon-big")
                    Text("You are sharing your screen")
                        .font(.heading6Semibold20)
                }
                .foreground(.onSurfaceHigh)
                
                HStack {
                    Image(systemName: "xmark")
                    Text("Stop Screenshare")
                }
                .font(.buttonSemibold16)
                .foreground(.errorBrighter)
                .padding()
                .background(.errorDefault, cornerRadius: 8)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

struct HMSLocalScreenShareView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSLocalScreenShareView()
            .environmentObject(HMSUITheme())
#endif
    }
}
