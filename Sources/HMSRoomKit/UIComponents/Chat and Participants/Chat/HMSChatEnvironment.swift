//
//  HMSChatEnvironment.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 1/15/24.
//

import SwiftUI

extension HMSChatListView {
    
    struct Appearance {
        
        public enum Position {
            case top, bottom
        }
        
        var pinnedMessagePosition: Position
        var isPlain = false
        
        public init(pinnedMessagePosition: Position, isPlain: Bool = false) {
            self.pinnedMessagePosition = pinnedMessagePosition
            self.isPlain = isPlain
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
