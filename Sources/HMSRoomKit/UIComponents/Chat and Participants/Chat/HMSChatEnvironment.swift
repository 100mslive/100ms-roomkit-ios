//
//  HMSChatEnvironment.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 1/15/24.
//

import SwiftUI

extension HMSChatListView {
    
    struct Appearance {
        
        enum Mode {
            case plain, transparent, none
        }
        
        public enum Position {
            case top, bottom
        }
        
        var pinnedMessagePosition: Position
        var mode = Mode.none
        
        public init(pinnedMessagePosition: Position = .top, mode: Mode = .none) {
            self.pinnedMessagePosition = pinnedMessagePosition
            self.mode = mode
        }
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<Appearance> = .constant(.init(pinnedMessagePosition: .top))
        }
    }
}

extension EnvironmentValues {
    
    var chatScreenAppearance: Binding<HMSChatListView.Appearance> {
        get { self[HMSChatListView.Appearance.Key.self] }
        set { self[HMSChatListView.Appearance.Key.self] = newValue }
    }
}
