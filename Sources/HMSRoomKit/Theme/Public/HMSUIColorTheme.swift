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

public class HMSUIColorTheme: ObservableObject {
    
    public init() {}
    
#if !Preview
    public init(colorPalette: HMSRoomLayout.LayoutData.Theme.ColorPalette) {
        self.primaryDefault = Color(hex: colorPalette.primary_default)
        self.primaryBright = Color(hex: colorPalette.primary_bright)
        self.primaryDim = Color(hex: colorPalette.primary_dim)
        self.primaryDisabled = Color(hex: colorPalette.primary_disabled)
        self.onPrimaryHigh = Color(hex: colorPalette.on_primary_high)
        self.onPrimaryMedium = Color(hex: colorPalette.on_primary_medium)
        self.onPrimaryLow = Color(hex: colorPalette.on_primary_low)
        self.secondaryDefault = Color(hex: colorPalette.secondary_default)
        self.secondaryBright = Color(hex: colorPalette.secondary_bright)
        self.secondaryDim = Color(hex: colorPalette.secondary_dim)
        self.secondaryDisabled = Color(hex: colorPalette.secondary_disabled)
        self.onSecondaryHigh = Color(hex: colorPalette.on_secondary_high)
        self.onSecondaryMedium = Color(hex: colorPalette.on_secondary_medium)
        self.onSecondaryLow = Color(hex: colorPalette.on_secondary_low)
        self.backgroundDefault = Color(hex: colorPalette.background_default)
        self.backgroundDim = Color(hex: colorPalette.background_dim)
        self.surfaceDefault = Color(hex: colorPalette.surface_default)
        self.surfaceBright = Color(hex: colorPalette.surface_bright)
        self.surfaceBrighter = Color(hex: colorPalette.surface_brighter)
        self.surfaceDim = Color(hex: colorPalette.surface_dim)
        self.onSurfaceHigh = Color(hex: colorPalette.on_surface_high)
        self.onSurfaceMedium = Color(hex: colorPalette.on_surface_medium)
        self.onSurfaceLow = Color(hex: colorPalette.on_surface_low)
        self.borderDefault = Color(hex: colorPalette.border_default)
        self.borderBright = Color(hex: colorPalette.border_bright)
        self.alertSuccess = Color(hex: colorPalette.alert_success)
        self.alertWarning = Color(hex: colorPalette.alert_warning)
        self.alertErrorDefault = Color(hex: colorPalette.alert_error_default)
        self.alertErrorBright = Color(hex: colorPalette.alert_error_bright)
        self.alertErrorBrighter = Color(hex: colorPalette.alert_error_brighter)
        self.alertErrorDim = Color(hex: colorPalette.alert_error_dim)
    }
#endif
    
    @Published public var alertSuccess: Color = Color(UIColor(red: 54/255, green: 179/255, blue: 126/255, alpha: 1.0))
    @Published public var alertWarning: Color = Color(UIColor(red: 255/255, green: 171/255, blue: 0/255, alpha: 1.0))
    
    
    @Published public var alertErrorDefault: Color = Color(UIColor(red: 199/255, green: 78/255, blue: 91/255, alpha: 1.0))
    @Published public var alertErrorBright: Color = Color(UIColor(red: 255/255, green: 178/255, blue: 182/255, alpha: 1.0))
    @Published public var alertErrorBrighter: Color = Color(UIColor(red: 255/255, green: 237/255, blue: 236/255, alpha: 1.0))
    @Published public var alertErrorDim: Color = Color(UIColor(red: 39/255, green: 0/255, blue: 5/255, alpha: 1.0))
    
    
    @Published public var borderDefault: Color = Color(UIColor(red: 29/255, green: 31/255, blue: 39/255, alpha: 1.0))
    @Published public var borderBright: Color = Color(UIColor(red: 39/255, green: 42/255, blue: 49/255, alpha: 1.0))
    
    
    @Published public var primaryDefault: Color = Color(UIColor(red: 37/255, green: 114/255, blue: 237/255, alpha: 1.0))
    @Published public var primaryBright: Color = Color(UIColor(red: 83/255, green: 141/255, blue: 255/255, alpha: 1.0))
    @Published public var primaryDim: Color = Color(UIColor(red: 0/255, green: 45/255, blue: 109/255, alpha: 1.0))
    @Published public var primaryDisabled: Color = Color(UIColor(red: 0/255, green: 66/255, blue: 153/255, alpha: 1.0))
    
    
    @Published public var surfaceDefault: Color = Color(UIColor(red: 25/255, green: 27/255, blue: 35/255, alpha: 1.0))
    @Published public var surfaceBright: Color = Color(UIColor(red: 39/255, green: 42/255, blue: 49/255, alpha: 1.0))
    @Published public var surfaceBrighter: Color = Color(UIColor(red: 46/255, green: 48/255, blue: 56/255, alpha: 1.0))
    @Published public var surfaceDim: Color = Color(UIColor(red: 17/255, green: 19/255, blue: 26/255, alpha: 1.0))
    
    
    @Published public var secondaryDefault: Color = Color(UIColor(red: 68/255, green: 73/255, blue: 84/255, alpha: 1.0))
    @Published public var secondaryBright: Color = Color(UIColor(red: 112/255, green: 119/255, blue: 139/255, alpha: 1.0))
    @Published public var secondaryDim: Color = Color(UIColor(red: 41/255, green: 48/255, blue: 66/255, alpha: 1.0))
    @Published public var secondaryDisabled: Color = Color(UIColor(red: 64/255, green: 71/255, blue: 89/255, alpha: 1.0))
    
    
    @Published public var backgroundDefault: Color = Color(UIColor(red: 11/255, green: 14/255, blue: 21/255, alpha: 1.0))
    @Published public var backgroundDim: Color = Color(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0))
    
    
    @Published public var onPrimaryHigh: Color = Color(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0))
    @Published public var onPrimaryMedium: Color = Color(UIColor(red: 204/255, green: 218/255, blue: 255/255, alpha: 1.0))
    @Published public var onPrimaryLow: Color = Color(UIColor(red: 132/255, green: 170/255, blue: 255/255, alpha: 1.0))
    

    @Published public var onSurfaceHigh: Color = Color(UIColor(red: 239/255, green: 240/255, blue: 250/255, alpha: 1.0))
    @Published public var onSurfaceMedium: Color = Color(UIColor(red: 197/255, green: 198/255, blue: 208/255, alpha: 1.0))
    @Published public var onSurfaceLow: Color = Color(UIColor(red: 143/255, green: 144/255, blue: 153/255, alpha: 1.0))
    
    @Published public var onSecondaryHigh: Color = Color(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0))
    @Published public var onSecondaryMedium: Color = Color(UIColor(red: 211/255, green: 217/255, blue: 240/255, alpha: 1.0))
    @Published public var onSecondaryLow: Color = Color(UIColor(red: 164/255, green: 171/255, blue: 192/255, alpha: 1.0))
}
