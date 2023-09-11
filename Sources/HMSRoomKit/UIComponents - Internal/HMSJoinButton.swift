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

struct HMSJoinButton: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @Binding var isJoining: Bool
    
    var body: some View {

        HMSJoinLabelView(userName: roomModel.userName, isJoining: $isJoining)
            
    }
}

struct HMSJoinButton_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSJoinButton(isJoining: .constant(true))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}

