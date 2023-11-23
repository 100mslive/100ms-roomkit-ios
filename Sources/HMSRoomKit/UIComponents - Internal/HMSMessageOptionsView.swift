//
//  HMSMessageOptionsView.swift
//  HMSRoomKit
//
//  Created by Dmitry Fedoseyev on 27.07.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels
import HMSSDK

struct HMSMessageOptionsView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    let messageModel: HMSMessage
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Text("Message Options")
                    .foreground(.onSurfaceHigh)
                    .font(.subtitle2Semibold16)
                
                Spacer()
                
                HMSXMarkView()
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding(.horizontal, 24)
            
            HMSDivider(color: currentTheme.colorTheme.borderBright).frame(width: 172)
            
            HStack {
                Image(assetName: "pin")
                    .frame(width: 20, height: 20)
                Text("Pin")
                    .font(.subtitle2Semibold14)
                
                Spacer()
            }
            .padding(16)
            .onTapGesture {
                roomModel.pinnedMessages.append("\(String(describing: messageModel.sender)): \(messageModel.message)")
                dismiss()
            }

            HStack {
                Image(assetName: "copy").frame(width: 20, height: 20)
                Text("Copy Text").font(.subtitle2Semibold14)
                
                Spacer()
            }
            .padding(16)
            .onTapGesture {
                UIPasteboard.general.string = messageModel.message
                dismiss()
            }
            
            HStack {
                Image(assetName: "circle-minus")
                    .frame(width: 20, height: 20)
                Text("Block from Chat")
                    .font(.subtitle2Semibold14)
                
                Spacer()
            }
            .foreground(.errorDefault)
            .padding(16)
            .onTapGesture {
                if let sender = messageModel.sender, let customerUserID = sender.customerUserID {
                    roomModel.chatPeerBlacklist.append(customerUserID)
                }
                dismiss()
            }
        }
        .foreground(.onSurfaceHigh)
        .background(.surfaceDefault, cornerRadius: 8, border: .borderBright, ignoringEdges: .all)
    }
}

struct HMSMessageOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSMessageOptionsView(messageModel: HMSMessage(message: "hey"))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
