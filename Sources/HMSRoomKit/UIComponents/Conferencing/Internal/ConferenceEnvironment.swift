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
        
        public static let defaultValue: HMSConferenceScreen.DefaultType = .default
    }
    
    var conferenceParams: HMSConferenceScreen.DefaultType {
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
    
    enum HMSCaptionsState {
        case hidden, visible, starting, failed
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<HMSCaptionsState> = .constant(.hidden)
        }
    }
    
    var captionsState: Binding<HMSCaptionsState> {
        get { self[HMSCaptionsState.Key.self] }
        set { self[HMSCaptionsState.Key.self] = newValue }
    }
}

internal extension HMSOptionSheetView {
    
    struct PollsOptionAppearance {
        public enum HMSPollsBadgeState {
            case badged, none
        }
        
        var badgeState: HMSPollsBadgeState
        var containsItems: Bool
        
        public init(_ badgeState: HMSPollsBadgeState, containsItems: Bool) {
            self.badgeState = badgeState
            self.containsItems = containsItems
        }
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<PollsOptionAppearance> = .constant(.init(.none, containsItems: false))
        }
    }
}

internal extension EnvironmentValues {

    var pollsOptionAppearance: Binding<HMSOptionSheetView.PollsOptionAppearance> {
        get { self[HMSOptionSheetView.PollsOptionAppearance.Key.self] }
        set { self[HMSOptionSheetView.PollsOptionAppearance.Key.self] = newValue }
    }
}
