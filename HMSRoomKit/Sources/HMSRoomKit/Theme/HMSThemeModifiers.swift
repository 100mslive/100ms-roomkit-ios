//
//  HMSUIBackground.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSFontModifier: ViewModifier {
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var font: HMSThemeFont

    func body(content: Content) -> some View {
        content
            .font(currentTheme.fontTheme.fontForToken(font))
    }
}

struct HMSForegroundModifier: ViewModifier {
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var themeColor: HMSThemeColor

    func body(content: Content) -> some View {
        content
            .foregroundColor(currentTheme.colorTheme.colorForToken(themeColor))
    }
}

struct HMSBackgroundModifier: ViewModifier {
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var cornerRadius: CGFloat
    var corners: UIRectCorner
    var themeColor: HMSThemeColor?
    var opacity: CGFloat
    var border: HMSThemeColor?
    var ignoringEdges: Edge.Set?

    func body(content: Content) -> some View {
        VStack {
            if let ignoringEdges = ignoringEdges {
                content
                    .background(
                        Rectangle()
                            .cornerRadius(cornerRadius, corners: corners)
                            .foregroundColor(themeColor == nil ? .clear : currentTheme.colorTheme.colorForToken(themeColor!).opacity(opacity))
                            .edgesIgnoringSafeArea(ignoringEdges)
                    )
            }
            else {
                content
                    .background(
                        Rectangle()
                            .cornerRadius(cornerRadius, corners: corners)
                            .foregroundColor(themeColor == nil ? .clear : currentTheme.colorTheme.colorForToken(themeColor!).opacity(opacity))
                    )
            }
        }
        .overlay(content: {
            if let border = border {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(currentTheme.colorTheme.colorForToken(border), lineWidth: 1)
            }
        })
    }
}

struct HMSControlsModifier: ViewModifier {
    
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .foreground(.onSurfaceHigh)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1.0)
                    .foreground(.borderBright)
            }
            .background(isEnabled ? nil : .surfaceBrighter, cornerRadius: 8, corners: .allCorners)
    }
}

extension View {
    func font(_ themeFont: HMSThemeFont) -> some View {
        self.modifier(HMSFontModifier(font: themeFont))
    }
    
    func foreground(_ themeColor: HMSThemeColor) -> some View {
        self.modifier(HMSForegroundModifier(themeColor: themeColor))
    }
    func background(_ themeColor: HMSThemeColor?, cornerRadius: CGFloat, corners: UIRectCorner = .allCorners, opacity: CGFloat = 1.0, border: HMSThemeColor? = nil, ignoringEdges: Edge.Set? = nil) -> some View {
        self.modifier(HMSBackgroundModifier(cornerRadius: cornerRadius, corners: corners, themeColor: themeColor, opacity: opacity, border: border, ignoringEdges: ignoringEdges))
    }
    
    func controlAppearance(isEnabled: Bool) -> some View {
        self.modifier(HMSControlsModifier(isEnabled: isEnabled))
    }
}


struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

struct MirrorV: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.radians(Double.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View {
    func mirrorV() -> some View {
        modifier(MirrorV())
    }
}
