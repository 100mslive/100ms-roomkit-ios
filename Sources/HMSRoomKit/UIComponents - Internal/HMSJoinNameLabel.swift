//
//  HMSJoinButton.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

struct HMSJoinNameLabel: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        HMSJoinNameView(name: $roomModel.userName)
    }
}

struct HMSJoinNamebox_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSJoinNameLabel()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}

