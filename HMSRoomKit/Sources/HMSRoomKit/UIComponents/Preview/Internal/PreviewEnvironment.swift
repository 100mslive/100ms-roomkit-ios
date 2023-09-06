//
//  Environment.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 12/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

internal extension EnvironmentValues {
    
    struct HMSPreviewComponentParamKey: EnvironmentKey {
        
        // Should never be used but it's required by EnvironmentKey protocol
        static let defaultValue: HMSPreviewScreen.DefaultType = HMSPreviewScreen.DefaultType(title: "defaultValue", subTitle: "defaultValue", joinButtonType: .join, joinButtonLabel: "defaultValue", goLiveButtonLabel: "defaultGoLive")
    }
    
    var previewComponentParam: HMSPreviewScreen.DefaultType {
        get { self[HMSPreviewComponentParamKey.self] }
        set { self[HMSPreviewComponentParamKey.self] = newValue }
    }
}
