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
    
    @State private var isPopoverPresented: Bool = false
    
    var body: some View {
        
        let chatScopes = conferenceParams.chat?.chatScopes
        
        var multipleRecipientsAvailable: Bool {
            
            guard let chatScopes else { return false }
            
            return chatScopes.count > 0 || chatScopes.contains(.private) || chatScopes.contains(where: { scope in
                switch scope {
                case .roles(_):
                    return true
                default:
                    return false
                }
            })
        }
        
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
            
            if multipleRecipientsAvailable {
                Image(assetName: "chevron-up")
                    .resizable()
                    .frame(width: 9, height: 5)
                    .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                    .foreground(.onSurfaceHigh)
                    .padding(EdgeInsets(top: 5, leading: 3, bottom: 5, trailing: 3))
            }
        }
        .padding(4)
        .background(.surfaceBright, cornerRadius: 4, opacity: 0.64, border: .borderBright)
        .onTapGesture {
            guard multipleRecipientsAvailable else { return }
            isPopoverPresented = true
        }
        .sheet(isPresented: $isPopoverPresented) {
            HMSSheet {
                HMSRolePickerOptionsView(selectedOption: $recipient)
            }
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}

struct HMSRolePicker_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSRolePicker(recipient: .constant(.peer(nil)))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
