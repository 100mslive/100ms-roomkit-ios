//
//  HMSChatFieldStrip.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSSendChatField: View {
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @Environment(\.keyboardState) private var keyboardState
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    let recipient: HMSRecipient
    
    @State var message: String = ""
    @State var inputValid: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if let chat = conferenceParams.chat {
            HStack(spacing: 16) {
                TextField("Send a message...", text: $message, prompt: Text(chat.messagePlaceholder)
                    .foregroundColor(currentTheme.colorTheme.onSurfaceLow))
                .textInputAutocapitalization(.sentences)
                .focused($isFocused)
                .onChange(of: isFocused, perform: { newValue in
                    keyboardState.wrappedValue = isFocused ? .visible : .hidden
                })
                .foreground(.onSurfaceHigh)
                .font(.body1Regular16)
                .onChange(of: message) { messsage in
                    inputValid = !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
                Image(assetName: "send")
                    .foreground(inputValid ? .onSurfaceHigh : .onSurfaceLow)
                    .onTapGesture {
                        guard inputValid else { return }
                        Task {
                            try await roomModel.send(message: message, to: recipient)
                            message = ""
                        }
                    }
            }
            .padding(.horizontal)
            .frame(height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(currentTheme.colorTheme.primaryDefault, lineWidth: isFocused ? 1 : 0)
            )
        }
    }
}

struct HMSSendChatField_Previews: PreviewProvider {
    static var previews: some View {
        HMSSendChatField(recipient: .everyone)
            .environmentObject(HMSUITheme())
    }
}
