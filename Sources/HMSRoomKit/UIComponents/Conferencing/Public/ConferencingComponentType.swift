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
                var screen: DefaultType = .default
                closure(&screen)
                return InternalType.default(screen)
            case .liveStreaming(let closure):
                var screen: DefaultType = .default
                closure(&screen)
                return InternalType.liveStreaming(screen)
            }
        }
    }
    
    public struct DefaultType {
        
        public static let `default`: Self = .init()
        internal init() {}

        public var chat: Chat? = .default
        
        public struct Chat {
            
            public static let `default`: Self = .init()
            internal init() {}
            
            public enum InitialState {
                case open
                case close
            }
            
            // chat states
            public var initialState: InitialState = .close
            public var isOverlay: Bool = false
            public var allowsPinningMessages: Bool = true
            public var title: String = "Live chat"
            public var messagePlaceholder: String = "Send a message"
            
            // chat controls
            public enum Scope: Equatable {
                case `public`
                case `private`
                case roles(whiteList: [String])
            }
            
            public var chatScopes: [Scope] = [.public, .private]
            
            public struct Controls {
                public let canDisableChat: Bool
                public let canBlockUser: Bool
                public let canHideMessage: Bool
                
                public init(canDisableChat: Bool, canBlockUser: Bool, canHideMessage: Bool) {
                    self.canDisableChat = canDisableChat
                    self.canBlockUser = canBlockUser
                    self.canHideMessage = canHideMessage
                }
            }
            
            public var controls: Controls? = .init(canDisableChat: false, canBlockUser: false, canHideMessage: false)
            
            public init(initialState: InitialState = .close,
                        isOverlay: Bool = false,
                        allowsPinningMessages: Bool = true,
                        title: String = "Live chat",
                        messagePlaceholder: String = "Send a message",
                        chatScopes: [Scope] = [.public, .private],
                        controls: Controls? = .init(canDisableChat: false, canBlockUser: false, canHideMessage: false)) {
                self.initialState = initialState
                self.isOverlay = isOverlay
                self.allowsPinningMessages = allowsPinningMessages
                self.title = title
                self.messagePlaceholder = messagePlaceholder
                self.chatScopes = chatScopes
                self.controls = controls ?? .init(canDisableChat: false, canBlockUser: false, canHideMessage: false)
            }
        }
        
        public var tileLayout: TileLayout? = TileLayout(grid: .default)
        
        public struct TileLayout: Codable {
            
            public static let defaultGrid: Self = .init(grid: .default)
            
            public let grid: Grid
            
            public init(grid: Grid) {
                self.grid = grid
            }
            
            public struct Grid: Codable {
                
                public static let `default`: Self = .init()
                internal init(){}
                
                public var isLocalTileInsetEnabled: Bool = false
                public var prominentRoles: [String] = []
                public var canSpotlightParticipant: Bool = true
                
                public init(isLocalTileInsetEnabled: Bool, prominentRoles: [String], canSpotlightParticipant: Bool) {
                    self.isLocalTileInsetEnabled = isLocalTileInsetEnabled
                    self.prominentRoles = prominentRoles
                    self.canSpotlightParticipant = canSpotlightParticipant
                }
            }
        }
        
        public var isHandRaiseEnabled = true
        
        public var onStageExperience: OnStageExperience? = nil
        public struct OnStageExperience {
            public let onStageRoleName: String
            public let rolesWhoCanComeOnStage: [String]
            public let bringToStageLabel: String
            public let removeFromStageLabel: String
            public let skipPreviewForRoleChange: Bool
        }
        
        public var header: ConferencingHeader? = nil
        public struct ConferencingHeader {
            public let title: String
            public let description: String
        }
        
        public var brb: BRB? = .default
        public struct BRB {
            public static let `default`: Self = .init()
            internal init() {}
        }
        
        public var participantList: ParticipantList? = .default
        public struct ParticipantList {
            public static let `default`: Self = .init()
            internal init() {}
        }
        
        public var noiseCancellation: NoiseCancellation? = .default
        public struct NoiseCancellation {
            public static let `default`: Self = .init(startsEnabled: false)
            public let startsEnabled: Bool
        }
        
        public init(chat: Chat? = .default, tileLayout: TileLayout? = .init(grid: .default), onStageExperience: OnStageExperience? = nil, brb: BRB? = .default, participantList: ParticipantList? = .default, header: ConferencingHeader? = nil, isHandRaiseEnabled: Bool) {
            self.chat = chat
            self.tileLayout = tileLayout
            self.onStageExperience = onStageExperience
            self.brb = brb
            self.participantList = participantList
            self.header = header
            self.isHandRaiseEnabled = isHandRaiseEnabled
        }
    }
}
