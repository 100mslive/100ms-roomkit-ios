//
//  ModelExtension.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 24/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK
import SwiftUI
import HMSRoomModels

// Objects shared in the room, available to all peer to read and write
extension HMSRoomModel {
    static let spotlightKey = "spotlight"
    var spotlightedPeer: HMSPeerModel? {
        get {
            let peerId = sharedStore?[HMSRoomModel.spotlightKey] as? String
            return peerModels.first{$0.id == peerId}
        }
        set {
            sharedStore?[HMSRoomModel.spotlightKey] = newValue?.id ?? ""
        }
    }
    
    struct PinnedMessage: Codable, Equatable, Hashable {
        var text: String
        var id: String
        var pinnedBy: String
    }
    static let pinnedMessageKey = "pinnedMessages"
    var pinnedMessages: [PinnedMessage] {
        get {
            if let array = sharedStore?[HMSRoomModel.pinnedMessageKey] as? [[String: Any]] {
                return array.map{PinnedMessage(text: $0["text"] as? String ?? "", id: $0["id"] as? String ?? "", pinnedBy: $0["pinned_by"] as? String ?? "")}
            }
            else {
                return []
            }
        }
        set {
            sharedStore?[HMSRoomModel.pinnedMessageKey] = newValue
        }
    }
    
    static let chatPeerBlacklistKey = "chatPeerBlacklist"
    var chatPeerBlacklist: [String] {
        get {
            sharedStore?[HMSRoomModel.chatPeerBlacklistKey] as? [String] ?? []
        }
        set {
            sharedStore?[HMSRoomModel.chatPeerBlacklistKey] = newValue
        }
    }
    
}

// Data in in-memory reactive store
extension HMSRoomModel {
    
    static let pinnedPeersKey = "pinnedPeers"
    var pinnedPeers: [HMSPeerModel] {
        get {
            let peers = inMemoryStore[HMSRoomModel.pinnedPeersKey] as? [HMSPeerModel]
            return peerModels.filter{peers?.contains($0) ?? false}
        }
        set {
            inMemoryStore[HMSRoomModel.pinnedPeersKey] = newValue
        }
    }
}

// Convenience properties and methods
extension HMSRoomModel {
    
    var highlightedPeers: [HMSPeerModel] {
        (spotlightedPeer != nil ? [spotlightedPeer!] : []) + pinnedPeers
    }
    
    func setUserStatus(_ status: HMSPeerModel.Status) async throws {
        guard let localPeerModel = localPeerModel, localPeerModel.status != status else { return }
        
        var brbOn = false
        var raiseHandOn = false
        
        switch (status) {
        case .beRightBack:
            brbOn = true
            break
        case .handRaised:
            raiseHandOn = true
            break
        case .none:
            break
        }
        
        localPeerModel.metadata[HMSPeerModel.Status.beRightBack.rawValue] = brbOn
        raiseHandOn ? try await raiseHand() : try await lowerHand()
    }
    
    var remotePeersWithRaisedHand: [HMSPeerModel] {
        remotePeerModels.filter{$0.status == .handRaised}
    }
    
    func visiblePeersInLayout(isUsingInset: Bool) -> [HMSPeerModel] {
        if isUsingInset {
            return remotePeerModelsExcludingViewers
        }
        else {
#if !Preview
            if let localPeerModel = localPeerModel, localPeerModel.role?.canPublish ?? false {
                return remotePeerModelsExcludingViewers + [localPeerModel]
            }
            else {
                return remotePeerModelsExcludingViewers
            }
#else
            if let localPeerModel = localPeerModel {
                return remotePeerModelsExcludingViewers + [localPeerModel]
            }
            else {
                return remotePeerModelsExcludingViewers
            }
#endif
        }
    }
    
    static let roleChangeDeclinedNotificationType = "role_change_declined"
    func declineChangeRoleRequestAndNotify() async throws {
#if !Preview
        guard let request = roleChangeRequests.first, let sender = request.requestedBy else { return }
        guard let senderPeerModel = (peerModels.first{$0.peer == sender}) else { return }

        try await declineChangeRoleRequest()
        try await send(message: "", to: .peer(senderPeerModel), type: HMSRoomModel.roleChangeDeclinedNotificationType)
#endif
    }
}
