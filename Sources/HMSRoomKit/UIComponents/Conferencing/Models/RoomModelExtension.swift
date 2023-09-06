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

// Objects share in the room, available to all peer to read and write
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
    
    static let pinnedMessageKey = "pinnedMessage"
    var pinnedMessage: String? {
        get {
            sharedStore?[HMSRoomModel.pinnedMessageKey] as? String
        }
        set {
            sharedStore?[HMSRoomModel.pinnedMessageKey] = newValue
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
    
    public func setUserStatus(_ status: HMSPeerModel.Status) {
        localPeerModel?.status = status
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

        try await declineChangeRoleRequest()
        try await send(message: "", type: HMSRoomModel.roleChangeDeclinedNotificationType, recipient: .peer(sender))
#endif
    }
    
    func lowerHand(of peer: HMSPeerModel) async throws {
#if !Preview
        try await send(message: "", type: "lower_hand", recipient: .peer(peer.peer))
#endif
    }
}
