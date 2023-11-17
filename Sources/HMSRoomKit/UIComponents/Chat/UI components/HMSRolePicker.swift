//
//  HMSRolePickerView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSRolePicker: View {
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @Binding var recipient: HMSRecipient
    
    var body: some View {
        
        let defaultScope = "everyone"
        
        HStack {
            if recipient.toString() == "Everyone" {
                Image(assetName: "people-icon")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foreground(.onSurfaceMedium)
            }
            else {
                Image(assetName: "person-icon")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foreground(.onSurfaceMedium)
            }
            Text(recipient.toString())
                .font(.captionRegular12)
                .foreground(.onSurfaceHigh)
//            Image(assetName: "chevron-up")
//                .resizable()
//                .frame(width: 9, height: 5)
//                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
//                .foreground(.onSurfaceHigh)
//                .padding(EdgeInsets(top: 5, leading: 3, bottom: 5, trailing: 3))
        }
        .padding(4)
        .background(.surfaceBright, cornerRadius: 4, opacity: 0.64, border: .borderBright)
        .onAppear() {
#if !Preview
            if defaultScope == "everyone" || defaultScope.isEmpty {
                recipient = .everyone
            }
            else {
                if let defaultRole = roomModel.roles.first(where: {$0.name == defaultScope}) {
                    recipient = .role(defaultRole)
                }
            }
#endif
        }
    }
}

struct HMSRolePicker_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSRolePicker(recipient: .constant(.everyone))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
