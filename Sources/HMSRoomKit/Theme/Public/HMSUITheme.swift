//
//  ThemeCenter.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 12/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import Combine
import HMSSDK

public class HMSUITheme: ObservableObject {
    public var fontTheme: HMSUIFontTheme
    public var colorTheme: HMSUIColorTheme
    public var logoURL: URL?
    
    public init(fontTheme: HMSUIFontTheme = HMSUIFontTheme(), colorTheme: HMSUIColorTheme = HMSUIColorTheme(), logoURL: URL? = nil) {
        self.fontTheme = fontTheme
        self.colorTheme = colorTheme
        self.logoURL = logoURL
    }
}
