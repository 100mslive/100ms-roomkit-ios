//
//  PreviewComponentType.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 25/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
#if !Preview
import HMSSDK
#endif

extension HMSConferenceScreen {
    
    internal enum InternalType {
        case `default`(DefaultType)
        case liveStreaming(DefaultType)
    }
    
    public enum `Type` {
        
        case `default`(((inout DefaultType) -> Void) = {_ in})
        case liveStreaming(((inout DefaultType) -> Void) = {_ in})
        
        internal func process() -> InternalType {
            
            switch self {
            case .default(let closure):
                var screen = DefaultType(chat: .init(), tileLayout: .init(grid: .init()))
                closure(&screen)
                return InternalType.default(screen)
            case .liveStreaming(let closure):
                var screen = DefaultType(chat: .init(), tileLayout: .init(grid: .init()))
                closure(&screen)
                return InternalType.liveStreaming(screen)
            }
        }
    }
    
    public struct DefaultType {

        public var chat: Chat? = .init()
        
        public struct Chat {
            
            public enum InitialState {
                case open
                case close
            }
            
            public var initialState: InitialState = .close
            public var isOverlay: Bool = false
            public var allowsPinningMessages: Bool = true
        }
        
        public var tileLayout: TileLayout? = TileLayout(grid: .init())
        
        public struct TileLayout: Codable {
            public let grid: Grid
            
            public struct Grid: Codable {
                public var isLocalTileInsetEnabled: Bool = true
                public var prominentRoles: [String] = []
                public var canSpotlightParticipant: Bool = true
            }
        }
        
        public var onStageExperience: OnStageExperience?
        public struct OnStageExperience {
            public let onStageRoleName: String
            public let rolesWhoCanComeOnStage: [String]
            public let bringToStageLabel: String
            public let removeFromStageLabel: String
        }
        
        public var brb: BRB?
        public struct BRB {}
        
        public var participantList: ParticipantList?
        public struct ParticipantList {}
    }
}
