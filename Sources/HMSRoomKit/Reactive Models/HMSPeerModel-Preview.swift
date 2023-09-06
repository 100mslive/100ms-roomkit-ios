//
//  HMSPeerModelExtension.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 27/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

#if Preview
extension HMSPeerModel {
    var audioTrackModels: [HMSTrackModel] { [HMSTrackModel()] }
    var regularVideoTrackModels: [HMSTrackModel] { [HMSTrackModel()] }
    var screenTrackModels: [HMSTrackModel] { [HMSTrackModel()] }
    var isSharingScreen: Bool { false }
}
#endif
