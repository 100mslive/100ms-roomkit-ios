//
//  HMSShareScreenButton.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 05/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSSessionMenuButton: View {
    var text: String
    var image: String
    var highlighted: Bool
    var badgeText: String?
    var isDisabled: Bool = false
    
    var body: some View {
        VStack {
            Image(assetName: image)
                .resizable()
                .frame(width: 21, height: 20)
                .foreground(isDisabled ? .onSurfaceLow : .onSurfaceHigh)
            Text(text).font(.captionSemibold)
                .multilineTextAlignment(.center)
                .foreground(isDisabled ? .onSurfaceLow : .onSurfaceHigh)
        }
        .frame(width: 109, height: 60)
        .overlay(alignment: .topTrailing) {
             if let badgeText = badgeText {
                 Text(badgeText)
                     .font(.overlineMedium).foreground(.onSurfaceHigh)
                     .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                     .background(.surfaceBright, cornerRadius: 40)
             }
        }
        .padding(.horizontal, 5)
        .background((isDisabled || !highlighted) ? nil : .surfaceBright, cornerRadius: 4)
    }
}
