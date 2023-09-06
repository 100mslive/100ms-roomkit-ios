//
//  Environment.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 12/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

internal extension EnvironmentValues {
    
    struct HMSConferenceComponentParamKey: EnvironmentKey {
        
        // Should never be used but it's required by EnvironmentKey protocol
        static let defaultValue: HMSConferenceScreen.DefaultType = HMSConferenceScreen.DefaultType()
    }
    
    var conferenceComponentParam: HMSConferenceScreen.DefaultType {
        get { self[HMSConferenceComponentParamKey.self] }
        set { self[HMSConferenceComponentParamKey.self] = newValue }
    }
}
