//
//  PreviewComponentType.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 25/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK

extension HMSPreviewScreen {
    
    internal enum InternalType {
        case `default`(DefaultType)
    }
    
    public enum `Type` {
        
        case `default`(((inout DefaultType) -> Void) = {_ in})
        
        internal func process() -> InternalType {
            
            switch self {
            case .default(let closure):
                var previewScreen: DefaultType = .default
                closure(&previewScreen)
                return InternalType.default(previewScreen)
            }
        }
    }
    
    public struct DefaultType {
        
        public static let defaultTitle: String = "Get Started"
        public static let defaultSubTitle: String = "Setup your audio and video before joining"
        public static let defaultJoinButtonType: JoinButtonType = .join
        public static let defaultJoinButtonLabel: String = "Join Now"
        public static let defaultGoLiveButtonLabel: String = "Go Live"
        
        public static let `default`: Self = .init()
        internal init() {}
        
        public enum JoinButtonType: Int, Codable {
            case join = 0
            case goLive = 1
        }
        
        public var title: String = defaultTitle
        public var subTitle: String = defaultSubTitle
        public var joinButtonType: JoinButtonType = defaultJoinButtonType
        public var joinButtonLabel: String = defaultJoinButtonLabel
        public var goLiveButtonLabel: String = defaultGoLiveButtonLabel
        
        public var noiseCancellation: NoiseCancellation? = .default
        public struct NoiseCancellation {
            public static let `default`: Self = .init(startsEnabled: false)
            public let startsEnabled: Bool
        }
        
        public var virtualBackgrounds: [VirtualBackground] = []
        public struct VirtualBackground {
            public let url: URL
            public let isDefault: Bool
            public let type: BackgroundType
            public enum BackgroundType: String {
                case image = "IMAGE"
                case video = "VIDEO"
            }
        }
        
        public init(title: String = defaultTitle, subTitle: String = defaultSubTitle, joinButtonType: JoinButtonType = defaultJoinButtonType, joinButtonLabel: String = defaultJoinButtonLabel, goLiveButtonLabel: String = defaultGoLiveButtonLabel, noiseCancellation: NoiseCancellation = .default, virtualBackgrounds: [VirtualBackground]) {
            self.title = title
            self.subTitle = subTitle
            self.joinButtonType = joinButtonType
            self.joinButtonLabel = joinButtonLabel
            self.goLiveButtonLabel = goLiveButtonLabel
            self.noiseCancellation = noiseCancellation
            self.virtualBackgrounds = virtualBackgrounds
        }
    }
}
