//
//  PickerField.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSPickerField: View {
    @State var title: String
    @State var options: [String]
    @Binding var selectedOption: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body2Regular14)
            }
            HStack {
                Menu {
                    Picker(selection: $selectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(HMSUIFontTheme().body1Regular16)
                                .foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                        }
                    } label: {}
                } label: {
                    Text(selectedOption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(HMSUIFontTheme().body1Regular16)
                        .foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                    
                }
                Image(systemName: "chevron.down").foregroundColor(HMSUIColorTheme().onPrimaryHigh)
            }
            .padding(16)
            .background(HMSUIColorTheme().surfaceBright)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(HMSUIColorTheme().borderBright, lineWidth: 1))
        }
    }
}
