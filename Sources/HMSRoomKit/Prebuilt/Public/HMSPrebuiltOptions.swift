//
//  HMSPrebuiltOptions.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 27/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import Combine
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

public class HMSPrebuiltOptions: ObservableObject {
    
    var theme: HMSUITheme?
    var roomOptions: HMSRoomOptions?
    var preferredExtensionName: String?
    
    public init(theme: HMSUITheme? = nil, roomOptions: HMSRoomOptions? = nil, preferredExtensionName: String? = nil) {
        self.theme = theme
        self.roomOptions = roomOptions
        self.preferredExtensionName = preferredExtensionName
    }
}
