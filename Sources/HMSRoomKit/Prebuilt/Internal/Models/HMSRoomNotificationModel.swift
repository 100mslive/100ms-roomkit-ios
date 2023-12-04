//
//  HMSRoomKitModel.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 28/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation

@MainActor
class HMSRoomNotificationModel: ObservableObject {
    
    deinit {
        print("deinit HMSRoomKitModel")
    }
    
    @Published var notifications = [HMSRoomKitNotification]()
}
