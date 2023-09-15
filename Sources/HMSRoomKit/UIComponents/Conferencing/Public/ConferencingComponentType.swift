//
//  PreviewComponentType.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 25/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK

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
            
            public static let `default`: Self = .init()
            internal init() {}
            public init(initialState: InitialState, isOverlay: Bool, allowsPinningMessages: Bool) {
                self.initialState = initialState
                self.isOverlay = isOverlay
                self.allowsPinningMessages = allowsPinningMessages
            }
        }
        
        public var tileLayout: TileLayout? = TileLayout(grid: .default)
        
        public struct TileLayout: Codable {
            public let grid: Grid
            public init(grid: Grid) {
                self.grid = grid
            }
            
            public struct Grid: Codable {
                
                public static let `default`: Grid = .init()
                
                public var isLocalTileInsetEnabled: Bool = true
                public var prominentRoles: [String] = []
                public var canSpotlightParticipant: Bool = true
                
                internal init(){}
                
                public init(isLocalTileInsetEnabled: Bool, prominentRoles: [String], canSpotlightParticipant: Bool) {
                    self.isLocalTileInsetEnabled = isLocalTileInsetEnabled
                    self.prominentRoles = prominentRoles
                    self.canSpotlightParticipant = canSpotlightParticipant
                }
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
        public struct BRB {
            public static let `default`: Self = .init()
            internal init() {}
        }
        
        public var participantList: ParticipantList?
        public struct ParticipantList {
            public static let `default`: Self = .init()
            internal init() {}
        }
    }
}
