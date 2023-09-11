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
    
    var userName: String?
    var theme: HMSUITheme?
    var roomOptions: HMSRoomOptions?
    
    public init(userName: String? = nil, theme: HMSUITheme? = nil, roomOptions: HMSRoomOptions? = nil) {
        self.userName = userName
        self.theme = theme
        self.roomOptions = roomOptions
    }
}
