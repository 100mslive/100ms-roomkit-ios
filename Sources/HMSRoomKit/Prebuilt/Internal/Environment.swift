//
//  Environment.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 12/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

// Menu / overlay context
extension EnvironmentValues {
    
    enum MenuContext {
        case none, oneClickDismiss, opaque
    }
    
    struct HMSMenuContextKey: EnvironmentKey {
        static let defaultValue: Binding<MenuContext> = .constant(.none)
    }
    
    var menuContext: Binding<MenuContext> {
        get { self[HMSMenuContextKey.self] }
        set { self[HMSMenuContextKey.self] = newValue }
    }
}

extension EnvironmentValues {
    
    enum LeaveContext {
        case none, cancel, leave, endSession
    }
    
    struct LeaveContextKey: EnvironmentKey {
        static let defaultValue: Binding<LeaveContext> = .constant(.none)
    }
    
    var leaveContext: Binding<LeaveContext> {
        get { self[LeaveContextKey.self] }
        set { self[LeaveContextKey.self] = newValue }
    }
}

extension EnvironmentValues {
    
    enum HMSControlsState {
        case hidden, none
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<HMSControlsState> = .constant(.none)
        }
    }
    
    var controlsState: Binding<HMSControlsState> {
        get { self[HMSControlsState.Key.self] }
        set { self[HMSControlsState.Key.self] = newValue }
    }
    
    enum HMSTabPageBarState {
        case visible, hidden
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<HMSTabPageBarState> = .constant(.hidden)
        }
    }
    
    var tabPageBarState: Binding<HMSTabPageBarState> {
        get { self[HMSTabPageBarState.Key.self] }
        set { self[HMSTabPageBarState.Key.self] = newValue }
    }
    
    enum HMSKeyboardState {
        case hidden, visible
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<HMSKeyboardState> = .constant(.hidden)
        }
    }
    
    var keyboardState: Binding<HMSKeyboardState> {
        get { self[HMSKeyboardState.Key.self] }
        set { self[HMSKeyboardState.Key.self] = newValue }
    }
}
