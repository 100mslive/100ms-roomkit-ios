//
//  HMSPeerModelExtension.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 27/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

@MainActor
extension HMSPeerModel {
    func insert(track: HMSTrack) {
        trackModels.append(HMSTrackModel(track: track, peerModel: self))
        if track.source == HMSCommonTrackSource.screen {
            roomModel?.didChangeScreenSharingState(for: self, state: .updated)
        }
        roomModel?.objectWillChange.send()
    }
    
    func remove(track: HMSTrack) {
        trackModels.removeAll{$0.track == track}
        if track.source == HMSCommonTrackSource.screen {
            roomModel?.didChangeScreenSharingState(for: self, state: .updated)
        }
        roomModel?.objectWillChange.send()
    }
    
    func updateRole() {
        
        role = peer.role
        updateMetadata()
        
        canScreenShare = role?.publishSettings.allowed?.contains("screen") ?? false
        roomModel?.didChangeScreenSharingState(for: self, state: .updated)
        canMute = peer.role?.permissions.mute ?? false
        self.canRemoveOthers = peer.role?.permissions.removeOthers ?? false
        
        self.canEndRoom = peer.role?.permissions.endRoom ?? false
        self.canStartStopHLSStream = peer.role?.permissions.hlsStreaming ?? false
        self.canStartStopRecording = peer.role?.permissions.browserRecording ?? false
        if isLocal {
            roomModel?.userCanEndRoom = canEndRoom
        }
        
        roomModel?.objectWillChange.send()
    }
    
    func updateName() {
        name = peer.name
        
        roomModel?.objectWillChange.send()
    }
    
    func updateDownlinkQuality() {
        downlinkQuality = peer.networkQuality?.downlinkQuality
        
        roomModel?.objectWillChange.send()
    }
    
    nonisolated func updateMetadata() {
        
        guard let metadataString = peer.metadata, let data = metadataString.data(using: .utf8), let newMetadata = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
        
        // remove keys which do not exist anymore
        for element in metadata {
            if !newMetadata.contains(where: {$0.key == element.key}) {
                metadata.setValue(nil, for: element.key)
            }
        }
        
        // add new keys
        for element in newMetadata {
            metadata.setValue(element.value, for: element.key)
        }
        roomModel?.objectWillChange.send()
    }
    
    func updateDegradation(for track: HMSTrack, isDegraded: Bool) {
        if let trackModel = trackModels.first(where: {$0.track == track}) {
            trackModel.isDegraded = isDegraded
            
            if trackModel == regularVideoTrackModel {
                isVideoDegraded = isDegraded
            }
            if trackModel == regularAudioTrackModel {
                isAudioDegraded = isDegraded
            }
        }
        roomModel?.objectWillChange.send()
    }
}
