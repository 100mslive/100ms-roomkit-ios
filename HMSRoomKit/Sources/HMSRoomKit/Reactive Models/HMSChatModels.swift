//
//  HMSCharModels.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 20/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK

public struct HMSMessageModel: Hashable, Identifiable {
    public let id: String
    
    public var message = ""
    public var sender = ""
    public var time = ""
    
    static var formatter = DateFormatter()
    
#if !Preview
    init(message: HMSMessage) {
        self.message = message.message
        let name = message.sender?.name ?? "bot"
        self.sender = name
        HMSMessageModel.formatter.timeStyle = .short
        self.time = HMSMessageModel.formatter.string(from: message.time)
        self.id = message.messageID
    }
#else

    init(message: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.") {
        self.message = message
        self.sender = "John Doe"
        self.time = HMSMessageModel.formatter.string(from: Date())
        self.id = UUID().uuidString
    }
#endif
}

public enum HMSRecipient {
    case everyone
    case role(RoleType)
    case peer(PeerType)
    
    public func toString() -> String {
        switch self {
            
        case .everyone:
            return "Everyone"
        case .role(let role):
            return role.name.capitalized
        case .peer(let peer):
            return peer.name
        }
    }
}

#if Preview
public typealias RoleType = PreviewRoleModel
public typealias PeerType = HMSPeerModel
#else
public typealias RoleType = HMSRole
public typealias PeerType = HMSPeer
#endif
