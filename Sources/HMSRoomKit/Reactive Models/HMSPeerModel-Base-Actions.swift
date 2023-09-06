//
//  HMSPeerModel-Base-Actions.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 21/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation

import SwiftUI

@MainActor
extension HMSPeerModel {
    
    public func toggleAudio() async throws {
        try await regularAudioTrackModel?.toggleMute()
    }
    
    public func toggleVideo() async throws {
        try await regularVideoTrackModel?.toggleMute()
    }
}
