//
//  PreviewScreen.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 12/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

public struct HMSConferenceScreen: View {
    
    let userName: String?
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomKitModel: HMSRoomKitModel
    
    let isDefaultType: Bool
    
    let type: InternalType
    public init(userName: String? = nil) {
        isDefaultType = true
        self.type = .default(.default)
        self.userName = userName
    }
    public init(userName: String? = nil, _ type: `Type`) {
        isDefaultType = false
        self.type = type.process()
        self.userName = userName
    }
    public init(userName: String? = nil, _ type: ()->`Type`) {
        isDefaultType = false
        let theType = type()
        self.type = theType.process()
        self.userName = userName
    }
    public init(userName: String? = nil, _ block: @escaping ((inout DefaultType) -> Void)) {
        isDefaultType = false
        let theType = `Type`.default(block)
        self.type = theType.process()
        self.userName = userName
    }
    
    @State var isPermissionDenialScreenPresented = false
    
    public var body: some View {
        
        Group {
            switch type {
            case .default(let conferenceParams):
                HMSDefaultConferenceScreen(isHLSViewer: false)
                    .environment(\.conferenceParams, isDefaultType ? conferenceComponentParam : conferenceParams)
                
            case .liveStreaming(let conferenceParams):
                HMSDefaultConferenceScreen(isHLSViewer: true)
                    .environment(\.conferenceParams, isDefaultType ? conferenceComponentParam : conferenceParams)
            }
        }
        .checkAccessibility(interval: 1, denial: $isPermissionDenialScreenPresented)
        .fullScreenCover(isPresented: $isPermissionDenialScreenPresented) {
            HMSPermissionDenialScreen()
        }
        .environmentObject(roomKitModel)
        .onAppear() {
            
            guard !roomModel.isUserJoined else { return }
            
            Task {
                if let userName = userName {
                    roomModel.userName = userName
                }
                try await roomModel.joinSession()
            }
        }
    }
}

struct HMSConferenceScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSConferenceScreen(.default())
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2, [.prominent, .prominent]))
            .environmentObject(HMSRoomKitModel())
            .environmentObject(HMSRoomInfoModel())
            .environment(\.conferenceParams, .init(chat: .init(initialState: .open, isOverlay: true, allowsPinningMessages: true), tileLayout: .init(grid: .init(isLocalTileInsetEnabled: true, prominentRoles: ["stage"], canSpotlightParticipant: true))))
#endif
    }
}
