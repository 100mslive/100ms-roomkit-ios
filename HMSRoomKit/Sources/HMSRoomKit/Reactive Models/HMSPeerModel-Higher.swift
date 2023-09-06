//
//  HMSPeerModelExtension.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 27/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

extension HMSPeerModel {
    public var regularAudioTrackModel: HMSTrackModel? {
        audioTrackModels.first
    }
    public var regularVideoTrackModel: HMSTrackModel? {
        regularVideoTrackModels.first
    }
    public var ScreenVideoTrackModel: HMSTrackModel? {
        screenTrackModels.first
    }
}
