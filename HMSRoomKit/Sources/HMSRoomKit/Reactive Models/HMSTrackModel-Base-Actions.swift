//
//  HMSTrackModel.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 31/05/2023.
//

import SwiftUI
import HMSSDK

// Toggle
@MainActor  
extension HMSTrackModel {
    
    public func toggleMute() async throws {
        
#if !Preview
        let newValue = !track.isMute()
        
        // preview tracks don't have peers so default to true
        if peerModel?.isLocal ?? true {
            
            if let localAudioTrack = track as? HMSLocalAudioTrack {
                localAudioTrack.setMute(newValue)
            }
            else if let localVideoTrack = track as? HMSLocalVideoTrack {
                localVideoTrack.setMute(newValue)
            }
            else {
                // custom track mute is not supported
            }
            self.isMute = newValue
        }
        else {
            try await peerModel?.roomModel?.changeTrackMuteState(for: self, mute: newValue)
        }
        peerModel?.objectWillChange.send()
        peerModel?.roomModel?.objectWillChange.send()

#endif
    }
}
