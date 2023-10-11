//
//  File.swift
//  
//
//  Created by Pawan Dixit on 11/10/2023.
//

import SwiftUI

public extension HMSPeerTile {
    
    struct Appearance {
        enum Mode {
            case compact, full
        }
        
        var mode: Mode
        var isOverlayHidden: Bool
        
        init(_ mode: Mode, isOverlayHidden: Bool) {
            self.mode = mode
            self.isOverlayHidden = isOverlayHidden
        }
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<Appearance> = .constant(.init(.full, isOverlayHidden: false))
        }
    }
}

public extension EnvironmentValues {

    var peerTileAppearance: Binding<HMSPeerTile.Appearance> {
        get { self[HMSPeerTile.Appearance.Key.self] }
        set { self[HMSPeerTile.Appearance.Key.self] = newValue }
    }
}
