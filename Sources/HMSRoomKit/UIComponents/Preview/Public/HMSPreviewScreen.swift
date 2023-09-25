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
    
    let userName: String?
    
    @Environment(\.previewParams) var previewComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
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
            case .default(let previewParams):
                HMSPreviewScreenLiveStreaming()
                    .environment(\.previewParams, isDefaultType ? previewComponentParam : previewParams)
            }
        }
        .checkAccessibility(interval: 1, denial: $isPermissionDenialScreenPresented)
        .fullScreenCover(isPresented: $isPermissionDenialScreenPresented) {
            HMSPermissionDenialScreen()
        }
        .onAppear() {
            
            guard !roomModel.isPreviewJoined else { return }
            
            Task {
                if let userName = userName {
                    roomModel.userName = userName
                }
                try await roomModel.preview()
            }
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
