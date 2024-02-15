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
    
    @Environment(\.chatScreenAppearance) var chatScreenAppearance
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var theme: HMSUITheme
    
    let messageModel: HMSMessage
    @Binding var recipient: HMSRecipient?
    
    @State var isPopoverPresented = false
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        
        let isPartOfTransparentChat = chatScreenAppearance.mode.wrappedValue == .transparent
        
        if chatScreenAppearance.mode.wrappedValue == .plain {
            messageView
        }
        else {
            if isPartOfTransparentChat {
                messageView
                    .padding(8)
                    .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
            }
            else {
                if messageModel.recipient.type != .broadcast {
                    messageView
                        .background(.surfaceDefault, cornerRadius: 8)
                }
                else {
                    messageView
                }
            }
        }
    }
    
    var messageView: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    
                    if chatScreenAppearance.mode.wrappedValue != .plain {
                        
                        Text(messageModel.sender?.name ?? "")
                            .font(.subtitle2Semibold14)
                            .foreground(.onSurfaceHigh)
                        
                        Text(formatter.string(from: messageModel.time))
                            .font(.captionRegular12).foreground(.onSurfaceMedium)
                        
                        if messageModel.recipient.type == .peer, let peerParticipant = messageModel.recipient.peerRecipient {
                            Text("to \(peerParticipant.isLocal ? "You" : peerParticipant.name) (DM)")
                                .lineLimit(1)
                                .font(.captionRegular12)
                                .foreground(.onSurfaceMedium)
                        }
                        else if messageModel.recipient.type == .roles, let firstRoleRecipient = messageModel.recipient.rolesRecipient?.first {
                            
                            Text("to \(firstRoleRecipient.name) (Group)")
                                .foreground(.onSurfaceMedium)
                                .font(.captionRegular12)
                                .lineLimit(1)
                        }

                        HStack {
                            
                            Spacer()
                            
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
                            .foreground(.onSurfaceLow)
                            .sheet(isPresented: $isPopoverPresented, content: {
                                HMSSheet {
                                    if verticalSizeClass == .regular {
                                        HMSMessageOptionsView(messageModel: messageModel, recipient: $recipient)
                                    }
                                    else {
                                        ScrollView {
                                            HMSMessageOptionsView(messageModel: messageModel, recipient: $recipient)
                                        }
                                    }
                                }
                                .edgesIgnoringSafeArea(.all)
                                .environmentObject(theme)
                            })
                        }
                    }
                }
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                .frame(maxWidth: .infinity)
                
                if chatScreenAppearance.mode.wrappedValue == .plain {
                    
                    var scopeString: String {
                        if messageModel.recipient.type == .peer, let peerParticipant = messageModel.recipient.peerRecipient {
                            return "to \(peerParticipant.isLocal ? "You" : peerParticipant.name) (DM)"
                        }
                        else if messageModel.recipient.type == .roles, let firstRoleRecipient = messageModel.recipient.rolesRecipient?.first {
                            
                            return "to \(firstRoleRecipient.name) (Group)"
                        }
                        
                        return ""
                    }
                    
                    Text("\(Text("\(messageModel.sender?.name ?? "")").font(HMSUIFontTheme().subtitle2Semibold14).foregroundColor(HMSUIColorTheme().onSurfaceLow)) \(Text(scopeString).font(HMSUIFontTheme().body2Regular14).foregroundColor(HMSUIColorTheme().onSurfaceMedium)) \(Text(LocalizedStringKey(messageModel.message)).font(HMSUIFontTheme().body2Regular14).foregroundColor(HMSUIColorTheme().onSurfaceHigh))")
                }
                else {
                    Text(LocalizedStringKey(messageModel.message))
                        .font(HMSUIFontTheme().body2Regular14)
                        .foregroundColor(HMSUIColorTheme().onSurfaceHigh)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct HMSChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
#if Preview
            HMSChatMessageView(messageModel: .init(message: "hello"), recipient: .constant(.everyone))
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
                .environment(\.chatScreenAppearance, .constant(.init(mode: .none)))
            
            HMSChatMessageView(messageModel: .init(message: "hello"), recipient: .constant(.everyone))
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
                .environment(\.chatScreenAppearance, .constant(.init(mode: .transparent)))
            
            HMSChatMessageView(messageModel: .init(message: "hello"), recipient: .constant(.everyone))
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
                .environment(\.chatScreenAppearance, .constant(.init(pinnedMessagePosition: .bottom, mode: .plain)))
#endif
        }
    }
}
