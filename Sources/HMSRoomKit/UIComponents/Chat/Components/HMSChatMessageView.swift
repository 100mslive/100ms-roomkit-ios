//
//  HMSChatMessageView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import Popovers
import HMSRoomModels

struct HMSChatMessageView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var theme: HMSUITheme
    
    let messageModel: HMSMessageModel
    var isPartOfTransparentChat: Bool
    
    @State var isPopoverPresented = false
    @State var action: HMSMessageOptionsView.Action = .none
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text(messageModel.sender)
                        .font(.subtitle2Semibold14)
                        .foreground(isPartOfTransparentChat ? .white : .onSurfaceHigh)
                        .shadow(color: isPartOfTransparentChat ? .black : .clear, radius: 3, y: 1)
                    
                    if !isPartOfTransparentChat {
                        Text(messageModel.time)
                            .font(.captionRegular12).foreground(.onSurfaceMedium)
                            .shadow(color: isPartOfTransparentChat ? .black : .clear, radius: 3, y: 1)
                    }
                    
                    Spacer()
                    
                    if !isPartOfTransparentChat {
                        Button() {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                                isPopoverPresented.toggle()
                            }
                            
                        } label: {
                            Image(assetName: "vertical-ellipsis")
                                .resizable()
                                .frame(width: 3.33, height: 15)
                                .padding(.horizontal, 9)
                        }
                        .foreground(.onSurfaceMedium)
                        .popover(present: $isPopoverPresented) {
                            HMSMessageOptionsView(action: $action, isPresented: $isPopoverPresented)
                                .environmentObject(theme)
                        }
                    }
                }
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                .frame(maxWidth: .infinity)
                Text(messageModel.message)
                    .font(.body2Regular14)
                    .foreground(isPartOfTransparentChat ? .white : .onSurfaceHigh)
                    .shadow(color: isPartOfTransparentChat ? .black : .clear ,radius: 3, y: 1)
                
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding(12)
        .cornerRadius(8)
        .onChange(of: action) { value in
            switch value {
            case .pin:
                roomModel.pinnedMessage = "\(messageModel.sender): \(messageModel.message)"
            case .copy:
                UIPasteboard.general.string = messageModel.message
            case .none:
                break
                
            }
        }
    }
}

struct HMSChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSChatMessageView(messageModel: .init(), isPartOfTransparentChat: true)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
