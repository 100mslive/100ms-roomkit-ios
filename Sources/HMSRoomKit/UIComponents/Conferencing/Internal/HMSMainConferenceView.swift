//
//  HMSConferenceMainView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 31/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels

struct HMSMainConferenceView: View {
    
    @Binding var isChatPresented: Bool
    let isHLSViewer: Bool
    let isChatOverlay: Bool
    
    var body: some View {
        
        GeometryReader { geo in
            
            if isHLSViewer {
                HMSHLSLayout()
            }
            else {
                HMSPeerLayout()
            }
        }
    }
}

struct HMSMainConferenceView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        let roomKitModel: HMSRoomNotificationModel = {
            let model = HMSRoomNotificationModel()
            model.notifications.append(.init(id: "id1", type: .handRaised(canBringOnStage: false), actor: "Pawan", isDismissible: true, title: "Peer1 raised hands Peer1 raised hands"))
            model.notifications.append(.init(id: "id2", type: .handRaised(canBringOnStage: false), actor: "Dmitry", isDismissible: true, title: "Peer2", isDismissed: true))
            model.notifications.append(.init(id: "id3", type: .handRaised(canBringOnStage: false), actor: "Praveen", isDismissible: true, title: "Peer3 raised hands"))
            model.notifications.append(.init(id: "id4", type: .handRaised(canBringOnStage: false), actor: "Bajaj", isDismissible: true, title: "Peer4 raised hands"))
            return model
        }()
        
        @State var isChatPresented = false
        
        HMSMainConferenceView(isChatPresented: $isChatPresented, isHLSViewer: true, isChatOverlay: false)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2, [.prominent, .prominent]))
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomInfoModel())
            .environmentObject(roomKitModel)
#endif
    }
}
