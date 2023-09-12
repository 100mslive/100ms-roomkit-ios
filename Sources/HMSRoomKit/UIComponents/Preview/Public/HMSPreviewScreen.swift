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

public struct HMSPreviewScreen: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
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
            case .default(let previewParams):
                HMSPreviewScreenLiveStreaming()
                    .environment(\.previewComponentParam, previewParams)
            }
        }
        .checkAccessibility(interval: 1, denial: $isPermissionDenialScreenPresented)
        .fullScreenCover(isPresented: $isPermissionDenialScreenPresented) {
            HMSPermissionDenialScreen()
        }
    }
}

struct HMSPreviewScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPreviewScreen(.default())
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
