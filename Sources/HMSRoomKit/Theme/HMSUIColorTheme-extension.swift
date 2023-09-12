//
//  HMSThemeColor.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import Combine
import HMSSDK

extension HMSUIColorTheme {
    
    func colorForToken(_ token: HMSThemeColor) -> Color {
        switch token {
        case .primaryDefault:
            return primaryDefault
        case .primaryBright:
            return primaryBright
        case .primaryDim:
            return primaryDim
        case .primaryDisabled:
            return primaryDisabled
        case .secondaryDefault:
            return secondaryDefault
        case .secondaryBright:
            return secondaryBright
        case .secondaryDim:
            return secondaryDim
        case .secondaryDisabled:
            return secondaryDisabled
        case .backgroundDefault:
            return backgroundDefault
        case .backgroundDim:
            return backgroundDim
        case .surfaceDefault:
            return surfaceDefault
        case .surfaceBright:
            return surfaceBright
        case .surfaceBrighter:
            return surfaceBrighter
        case .surfaceDim:
            return surfaceDim
        case .borderDefault:
            return borderDefault
        case .borderBright:
            return borderBright
        case .onPrimaryHigh:
            return onPrimaryHigh
        case .onPrimaryMedium:
            return onPrimaryMedium
        case .onPrimaryLow:
            return onPrimaryLow
        case .onSecondaryHigh:
            return onSecondaryHigh
        case .onSecondaryMedium:
            return onSecondaryMedium
        case .onSecondaryLow:
            return onSecondaryLow
        case .onSurfaceHigh:
            return onSurfaceHigh
        case .onSurfaceMedium:
            return onSurfaceMedium
        case .onSurfaceLow:
            return onSurfaceLow
        case .alertSuccess:
            return alertSuccess
        case .alertWarning:
            return alertWarning
        case .errorDefault:
            return alertErrorDefault
        case .errorBright:
            return alertErrorBright
        case .errorBrighter:
            return alertErrorBrighter
        case .errorDim:
            return alertErrorDim
        case .white:
            return .white
        }
    }
}

public enum HMSThemeColor {
    case primaryDefault
    case primaryBright
    case primaryDim
    case primaryDisabled
    
    case secondaryDefault
    case secondaryBright
    case secondaryDim
    case secondaryDisabled
    
    case backgroundDefault
    case backgroundDim
    
    case surfaceDefault
    case surfaceBright
    case surfaceBrighter
    case surfaceDim
    
    case borderDefault
    case borderBright
    
    case onPrimaryHigh
    case onPrimaryMedium
    case onPrimaryLow
    
    case onSecondaryHigh
    case onSecondaryMedium
    case onSecondaryLow
    
    case onSurfaceHigh
    case onSurfaceMedium
    case onSurfaceLow
    
    case alertSuccess
    case alertWarning
    
    case errorDefault
    case errorBright
    case errorBrighter
    case errorDim
    
    case white
}

extension Color {
    init(hex: String) {
        var formattedString = hex
        if formattedString.hasPrefix("#") {
            formattedString.remove(at: formattedString.startIndex)
        }
        
        if let hexValue = Int(formattedString, radix: 16) {
            let red = Double((hexValue >> 16) & 0xFF) / 255.0
            let green = Double((hexValue >> 8) & 0xFF) / 255.0
            let blue = Double(hexValue & 0xFF) / 255.0
            
            self.init(red: red, green: green, blue: blue)
            return
        }
        
        fatalError("Invalid hexadecimal color code: \(hex)")
    }
}
