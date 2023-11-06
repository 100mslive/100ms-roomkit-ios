//
//  PollTextField.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct PollTextField: View {
    var placeholder: String
    @Binding var text: String
    var valid: Bool = true
    @State private var editing = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            TextField("", text: $text, onEditingChanged: { edit in
                self.editing = edit
            })
                .font(HMSUIFontTheme().body1Regular16)
                .foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                .textFieldStyle(HMSMainTextFieldStyle(focused: $editing, valid: valid))
            
            if text.isEmpty {
                Text(placeholder).font(HMSUIFontTheme().body1Regular16)
                    .foregroundColor(HMSUIColorTheme().secondaryDisabled)
                .padding(.horizontal, 16).allowsHitTesting(false)
            }
        }
    }
}
