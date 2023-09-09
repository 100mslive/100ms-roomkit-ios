//
//  HMSUIFontTheme.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 28/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import Combine

extension HMSUIFontTheme {
    func fontForToken(_ token: HMSThemeFont) -> Font {
         switch token {
         case .captionRegular12:
             return captionRegular
         case .captionSemibold:
             return captionSemibold
         case .body2Regular14:
             return body2Regular14
         case .body1Regular16:
             return body1Regular16
         case .body1Semibold16:
             return body1Semibold16
         case .body2Semibold14:
             return body2Semibold14
         case .subtitle1:
             return subtitle1
         case .subtitle2Semibold14:
             return subtitle2Semibold14
         case .buttonSemibold16:
             return buttonSemibold16
         case .overlineMedium:
             return overlineMedium
         case .heading6Semibold20:
             return heading6Semibold20
         case .heading4Semibold34:
             return heading4Semibold34
         case .heading5Semibold24:
             return heading5Semibold24
         }
     }
}

public enum HMSThemeFont {
    case captionRegular12
    case captionSemibold
    case body2Regular14
    case body1Regular16
    case body1Semibold16
    case body2Semibold14
    case subtitle1
    case subtitle2Semibold14
    case buttonSemibold16
    case overlineMedium
    case heading6Semibold20
    case heading4Semibold34
    case heading5Semibold24
}
