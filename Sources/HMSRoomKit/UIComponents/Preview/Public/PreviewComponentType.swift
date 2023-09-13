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
                var previewScreen = DefaultType(title: "Get Started", subTitle: "Setup your audio and video before joining", joinButtonType: .join, joinButtonLabel: "Join Now", goLiveButtonLabel: "Go Live")
                closure(&previewScreen)
                return InternalType.default(previewScreen)
            }
        }
    }
    
    public struct DefaultType {
        
        public enum JoinButtonType: Int, Codable {
            case join = 0
            case goLive = 1
        }
        
        public var title: String
        public var subTitle: String
        public var joinButtonType: JoinButtonType
        public var joinButtonLabel: String
        public var goLiveButtonLabel: String
    }
}
