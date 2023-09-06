//
//  HMSPeerModelExtension.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 27/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

// Convenience computed properties
extension HMSPeerModel {
    public var audioTrackModels: [HMSTrackModel] {
        trackModels.filter{$0.track is HMSAudioTrack}
    }
    public var regularVideoTrackModels: [HMSTrackModel] {
        trackModels.filter{$0.track is HMSVideoTrack && $0.track.source == HMSCommonTrackSource.regular}
    }
    public var screenTrackModels: [HMSTrackModel] {
        trackModels.filter{$0.track is HMSVideoTrack && $0.track.source == HMSCommonTrackSource.screen}
    }
    public var isSharingScreen: Bool {
        trackModels.contains{$0.track.source == HMSCommonTrackSource.screen}
    }
}

// Mute and unmute
extension HMSPeerModel {
    func mute(track: HMSTrack) {
        if let index = trackModels.firstIndex(where: {$0.track == track}) {
            trackModels[index].isMute = true
        }
    }
    func unmute(track: HMSTrack) {
        if let index = trackModels.firstIndex(where: {$0.track == track}) {
            trackModels[index].isMute = false
        }
    }
}
