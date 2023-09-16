//
//  Environment.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 12/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI


public extension EnvironmentValues {
    struct HMSConferenceComponentParamKey: EnvironmentKey {
        
        // Should never be used but it's required by EnvironmentKey protocol
        public static let defaultValue: HMSConferenceScreen.DefaultType = .default
    }
    
    var conferenceComponentParam: HMSConferenceScreen.DefaultType {
        get { self[HMSConferenceComponentParamKey.self] }
        set { self[HMSConferenceComponentParamKey.self] = newValue }
    }
}

internal extension EnvironmentValues {
    
    enum HMSChatBadgeState {
        case badged, none
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<HMSChatBadgeState> = .constant(.none)
        }
    }
    
    var chatBadgeState: Binding<HMSChatBadgeState> {
        get { self[HMSChatBadgeState.Key.self] }
        set { self[HMSChatBadgeState.Key.self] = newValue }
    }
}
