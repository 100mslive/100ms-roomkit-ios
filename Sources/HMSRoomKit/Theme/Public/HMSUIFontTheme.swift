//
//  HMSUIFontTheme.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 28/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import Combine

public class HMSUIFontTheme: ObservableObject {
    public var captionRegular = Font(UIFont(name: "Inter-Regular", size: 12) ?? .systemFont(ofSize: 12))
    public var captionSemibold12 = Font(UIFont(name: "Inter-SemiBold", size: 12) ?? .systemFont(ofSize: 12, weight: .semibold))
    public var body2Regular14 =  Font(UIFont(name: "Inter-Regular", size: 14) ?? .systemFont(ofSize: 14))
    public var body1Regular16 =  Font(UIFont(name: "Inter-Regular", size: 16) ?? .systemFont(ofSize: 16))
    public var body1Semibold16 =  Font(UIFont(name: "Inter-SemiBold", size: 16) ?? .systemFont(ofSize: 16, weight: .semibold))
    public var body2Semibold14 =  Font(UIFont(name: "Inter-SemiBold", size: 14) ?? .systemFont(ofSize: 14, weight: .semibold))
    public var subtitle1 =  Font(UIFont(name: "Inter-SemiBold", size: 16) ?? .systemFont(ofSize: 16, weight: .semibold))
    public var subtitle2Semibold14 =  Font(UIFont(name: "Inter-SemiBold", size: 14) ?? .systemFont(ofSize: 14, weight: .semibold))
    public var subtitle2Semibold16 =  Font(UIFont(name: "Inter-SemiBold", size: 16) ?? .systemFont(ofSize: 16, weight: .semibold))
    public var buttonSemibold16 = Font(UIFont(name: "Inter-SemiBold", size: 16) ?? .systemFont(ofSize: 16, weight: .semibold))
    public var overlineMedium =  Font(UIFont(name: "Inter-SemiBold", size: 10) ?? .systemFont(ofSize: 10, weight: .semibold))
    public var heading6Semibold20 =  Font(UIFont(name: "Inter-SemiBold", size: 20) ?? .systemFont(ofSize: 20, weight: .semibold))
    public var heading4Semibold34 =  Font(UIFont(name: "Inter-SemiBold", size: 34) ?? .systemFont(ofSize: 34))
    public var heading5Semibold24 =  Font(UIFont(name: "Inter-SemiBold", size: 24) ?? .systemFont(ofSize: 24, weight: .semibold))
    
    public init () {}
}
