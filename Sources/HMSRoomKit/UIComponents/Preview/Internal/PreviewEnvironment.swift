//
//  Environment.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 12/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

public extension EnvironmentValues {
    
    struct HMSPreviewComponentParamKey: EnvironmentKey {
        
        public static let defaultValue: HMSPreviewScreen.DefaultType = .default
    }
    
    var previewParams: HMSPreviewScreen.DefaultType {
        get { self[HMSPreviewComponentParamKey.self] }
        set { self[HMSPreviewComponentParamKey.self] = newValue }
    }
}
