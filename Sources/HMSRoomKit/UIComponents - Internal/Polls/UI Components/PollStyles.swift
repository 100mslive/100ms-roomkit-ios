//
//  PollStyles.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    internal init(isWide: Bool = true) {
        self.isWide = isWide
    }
    
    var isWide: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(HMSUIFontTheme().buttonSemibold16)
            .foregroundColor(HMSUIColorTheme().onPrimaryHigh)
            .frame(maxWidth: isWide ? .infinity : nil, alignment: .center)
            .padding(.vertical, 10)
            .padding(.horizontal, 24)
            .background(HMSUIColorTheme().primaryDefault)
            .cornerRadius(8)
    }
}

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder).font(HMSUIFontTheme().body1Regular16)
                    .foregroundColor(HMSUIColorTheme().secondaryDisabled)
                .padding(.horizontal, 0)
            }
            content
            .foregroundColor(Color.white)
        }
    }
}

struct HMSMainTextFieldStyle: TextFieldStyle {
    @Binding var focused: Bool
    var valid: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(valid ? HMSUIColorTheme().surfaceBright : HMSUIColorTheme().alertErrorDim)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(valid ? (focused ? HMSUIColorTheme().primaryDefault : HMSUIColorTheme().surfaceBright) : HMSUIColorTheme().alertErrorDefault , lineWidth: 1))
    }
}

struct HMSIconTextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(HMSUIFontTheme().body1Regular16)
            .foregroundColor(HMSUIColorTheme().onPrimaryMedium)
            .padding(12)
    }
}

struct ActionButtonLowEmphStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(HMSUIFontTheme().buttonSemibold16)
            .foregroundColor(HMSUIColorTheme().onPrimaryHigh)
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
            .background(HMSUIColorTheme().secondaryDefault)
            .cornerRadius(8)
    }
}
