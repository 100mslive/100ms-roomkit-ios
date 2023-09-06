//
//  HMSRoomModelPreviewExtension.swift
//  HMSSwiftUIPreviewDummy
//
//  Created by Pawan Dixit on 27/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation

extension HMSRoomModel {

    public var previewAudioTrack: HMSTrackModel? { HMSTrackModel() }
    public var previewVideoTrack: HMSTrackModel? { HMSTrackModel() }
    public var localVideoTrackModel: HMSTrackModel? { HMSTrackModel() }
    public var localAudioTrackModel: HMSTrackModel? { HMSTrackModel() }
    
    public var isUserHLSViewer: Bool {
        false
    }
    
    enum AdditionalPeers {
        case screen
        case prominent
    }
    
    static let localPeer = HMSPeerModel(name: "Local Peer", isLocal: true)
    private static let prominentPeers = [HMSPeerModel(name: "Prominent Peer \(1)"), HMSPeerModel(name: "Prominent Peer \(2)"), HMSPeerModel(name: "Prominent Peer \(3)"), HMSPeerModel(name: "Prominent Peer \(4)")]
    static func prominentPeers(_ count: Int) -> [HMSPeerModel] {
        Array(prominentPeers.prefix(count))
    }
    static var screenSharingPeers = [HMSPeerModel]()
    static func dummyRoom(_ remotePeerCount: Int, _ additionalPeers: [AdditionalPeers] = []) -> HMSRoomModel {
        
        let room = HMSRoomModel()
        room.recordingState = .recording
        room.isBeingStreamed = true
        room.isUserJoined = true
        room.userCanEndRoom = true
        
        room.pinnedMessage = "This :  is a pinned message"
        
        room.messages = [HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(), HMSMessageModel(message: "last")]
        
        room.userName = "Pawan's iOS"
        room.roles = [PreviewRoleModel(name: "host"), PreviewRoleModel(name: "guest")]
        
        var peers = [localPeer]
        if remotePeerCount > 0 {
            peers.append(contentsOf: (0..<remotePeerCount).map { i in HMSPeerModel(name: "Remote Peer \(i)", role: room.roles[i % 2]) })
        }
        peers.forEach {
            $0.downlinkQuality = Int.random(in: 0..<5)
        }
        
        if additionalPeers.contains(.screen) {
            let count = additionalPeers.filter{$0 == .screen}.count
            
            for i in 0..<count {
                let peer = HMSPeerModel(name: "ScreenSharing Peer \(i)")
                room.peersSharingScreen.append(peer)
                peers.append(peer)
                screenSharingPeers.append(peer)
            }
        }
        if additionalPeers.contains(.prominent) {
            let count = additionalPeers.filter{$0 == .prominent}.count
            
            let prominentPeers = prominentPeers.prefix(count)
            peers.append(contentsOf: prominentPeers)
        }
        room.isBeingStreamed = true
        room.peerModels = peers
        
        room.peerCount = peers.count
        
        return room
    }
}
