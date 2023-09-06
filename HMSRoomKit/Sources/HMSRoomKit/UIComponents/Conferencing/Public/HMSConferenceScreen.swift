//
//  PreviewScreen.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 12/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

public struct HMSConferenceScreen: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    @StateObject var roomKitModel = HMSRoomKitModel()
    
    let type: InternalType
    public init(_ type: `Type` = .default()) {
        self.type = type.process()
    }
    public init(_ type: ()->`Type`) {
        let theType = type()
        self.type = theType.process()
    }
    public init(_ block: @escaping ((inout DefaultType) -> Void)) {
        let theType = `Type`.default(block)
        self.type = theType.process()
    }
    
    @State var isPermissionDenialScreenPresented = false
    
    public var body: some View {
        
        Group {
            switch type {
            case .default(let conferenceParams):
                HMSDefaultConferenceScreen(isHLSViewer: false)
                    .environment(\.conferenceComponentParam, conferenceParams)
                
            case .liveStreaming(let conferenceParams):
                HMSDefaultConferenceScreen(isHLSViewer: true)
                    .environment(\.conferenceComponentParam, conferenceParams)
            }
        }
        .checkAccessibility(interval: 1, denial: $isPermissionDenialScreenPresented)
        .fullScreenCover(isPresented: $isPermissionDenialScreenPresented) {
            HMSPermissionDenialScreen()
        }
        .environmentObject(roomKitModel)
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
            .environment(\.conferenceComponentParam, .init(chat: .init(initialState: .open, isOverlay: true), tileLayout: .init(grid: .init(prominentRoles: ["stage"]))))
#endif
    }
}
