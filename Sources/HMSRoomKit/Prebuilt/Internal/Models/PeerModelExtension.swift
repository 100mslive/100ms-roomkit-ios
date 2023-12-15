//
//  PeerModelExtension.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 31/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

// Objects attached to a peer, available to all peer to read and and owner peer to write
extension HMSPeerModel {
    
    // Peer status
    public enum Status: String, CaseIterable {
        case none
        case handRaised = "isHandRaised"
        case beRightBack = "isBRBOn"
    }
    public var status: Status {
        get {
            if metadata[Status.beRightBack.rawValue] as? Bool ?? false {
                return .beRightBack
            }
            else if isHandRaised {
                return .handRaised
            }
            else {
                return .none
            }
        }
    }
    
    // Remember previous role so that peer is remove from stage to it's previous role
    static let previousRoleKey = "prevRole"
    var previousRole: String {
        get {
            metadata[HMSPeerModel.previousRoleKey] as? String ?? ""
        }
        set {
            metadata[HMSPeerModel.previousRoleKey] = newValue
        }
    }
}

// Data in in-memory static store
extension HMSPeerModel {

    // To store default tile color for a peer
    static let tileColorKey = "tileColor"
    var tileColor: Color {
        get {
            if inMemoryStaticStore[HMSPeerModel.tileColorKey] as? Color == nil {
                inMemoryStaticStore[HMSPeerModel.tileColorKey] = Color(assetName: "random-\([1,2,3,4,5,6,7,8].randomElement()!)")
            }
            
            return inMemoryStaticStore[HMSPeerModel.tileColorKey] as? Color ?? Color(assetName: "random-\([1].randomElement()!)")
        }
        set {}
    }
}
