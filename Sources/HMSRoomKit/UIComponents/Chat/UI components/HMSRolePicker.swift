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
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    let roles: [RoleType]
    @Binding var recipient: HMSRecipient
    
    @State private var isPopoverPresented: Bool = false
    
    var body: some View {
        
        HStack {
            Text(recipient.toString())
                .font(.captionRegular12)
                .foreground(.onSurfaceHigh)
            Image(assetName: "chevron-up")
                .resizable()
                .frame(width: 9, height: 5)
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .foreground(.onSurfaceHigh).padding(EdgeInsets(top: 5, leading: 3, bottom: 5, trailing: 3))
        }
        .padding(8)
        .onTapGesture {
            isPopoverPresented = true
        }
        .sheet(isPresented: $isPopoverPresented) {
            HMSRolePickerOptionsView(selectedOption: $recipient)
        }
        .background(.backgroundDim, cornerRadius: 4, opacity: 0.64, border: .borderBright)
    }
}

struct HMSRolePicker_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSRolePicker(roles: [.init(name: "Viewer"), .init(name: "Host")], recipient: .constant(.everyone))
            .environmentObject(HMSUITheme())
#endif
    }
}
