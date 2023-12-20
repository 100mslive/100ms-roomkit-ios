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
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @Binding var recipient: HMSRecipient?
    
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
            if case .peer(_) = recipient {
                Image(assetName: "person-icon")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foreground(.onSurfaceMedium)
            }
            else {
                Image(assetName: "people-icon")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foreground(.onSurfaceMedium)
            }
            
            if case let .peer(peer) = recipient {
                if roomModel.remotePeerModels.contains(peer) {
                    Text(recipient!.toString())
                        .font(.captionRegular12)
                        .foreground(.onPrimaryHigh)
                }
                else {
                    Text("Choose a recipient")
                        .font(.captionRegular12)
                        .foreground(.onPrimaryHigh)
                        .onAppear() {
                            recipient = nil
                        }
                }
            }
            else {
                Text(recipient?.toString() ?? "Choose a recipient")
                    .font(.captionRegular12)
                    .foreground(.onPrimaryHigh)
            }
            
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
        .background(.primaryDefault, cornerRadius: 4)
        .onTapGesture {
            guard multipleRecipientsAvailable else { return }
            // avoid keyboard UI constraint hang
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isPopoverPresented = true
        }
        .sheet(isPresented: $isPopoverPresented) {
            HMSSheet {
                if verticalSizeClass == .regular {
                    HMSRolePickerOptionsView(selectedOption: $recipient)
                }
                else {
                    ScrollView {
                        HMSRolePickerOptionsView(selectedOption: $recipient)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}

struct HMSRolePicker_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSRolePicker(recipient: .constant(nil))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(0))
            .environment(\.conferenceParams, .init(chat: .init(chatScopes: [.private])))
#endif
    }
}
