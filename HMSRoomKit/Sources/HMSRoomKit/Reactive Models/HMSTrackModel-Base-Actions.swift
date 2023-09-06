//
//  HMSTrackModel.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 31/05/2023.
//

import SwiftUI

// Toggle
@MainActor  
extension HMSTrackModel {
    
    public func toggleMute() async throws {
        
#if !Preview
        let newValue = !track.isMute()
        
        // preview tracks don't have peers so default to true
        if peerModel?.isLocal ?? true {
            
            track.setMute(newValue)
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
