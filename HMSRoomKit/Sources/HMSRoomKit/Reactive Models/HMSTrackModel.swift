//
//  HMSTrackModel.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 31/05/2023.
//

import SwiftUI
import Combine
import HMSSDK

public class HMSTrackModel: ObservableObject {
    
    @Published public var isMute = false
    @Published public var isDegraded = false
    
#if !Preview
    
    weak var peerModel: HMSPeerModel?
    public let track: HMSTrack
   
    public init(track: HMSTrack, peerModel: HMSPeerModel?) {
        self.track = track
        self.isMute = track.isMute()
        self.peerModel = peerModel
        self.isDegraded = (track as? HMSVideoTrack)?.isDegraded() ?? false
    }
    
#else
    let trackId: String
    init() {
        trackId = UUID().uuidString
        isMute = true
    }
#endif
}

// Hashable
extension HMSTrackModel: Hashable {
    public static func == (lhs: HMSTrackModel, rhs: HMSTrackModel) -> Bool {
#if !Preview
        lhs.track == rhs.track
#else
        lhs.trackId == rhs.trackId
#endif
    }
    public func hash(into hasher: inout Hasher) {
#if !Preview
        return hasher.combine(track)
#else
        return hasher.combine(trackId)
#endif
    }
}

