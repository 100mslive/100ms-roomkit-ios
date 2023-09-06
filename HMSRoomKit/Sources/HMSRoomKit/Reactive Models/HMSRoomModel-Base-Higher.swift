//
//  HMSRoomModelExtension.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 27/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

// Convenience computed properties

extension HMSRoomModel {
    
    public var localPeerModel: HMSPeerModel? {
        peerModels.first{$0.isLocal}
    }
    
    public var remotePeerModels: [HMSPeerModel] {
        peerModels.filter{!$0.isLocal}
    }
    
    public var remotePeerModelsExcludingViewers: [HMSPeerModel] {
#if !Preview
        remotePeerModels.filter{$0.role?.canPublish ?? false}
#else
        remotePeerModels
#endif
    }
}

extension HMSRole {
    public var canPublish: Bool {
        !(publishSettings.allowed?.isEmpty ?? true)
    }
}
