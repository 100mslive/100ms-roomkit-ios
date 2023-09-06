//
//  HMSRoomView.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 29/05/2023.
//

import SwiftUI
import HMSSDK
import Combine

public struct HMSPrebuiltView: View {
    
    @StateObject var roomInfoModel = HMSRoomInfoModel()
    
    let roomCode: String
    let onDismiss: (() -> Void)?
    let options: HMSPrebuiltOptions
    
    let roomModel: HMSRoomModel
    
    public init(roomCode: String, options: HMSPrebuiltOptions? = nil, onDismiss: (() -> Void)? = nil) {
        
        roomModel = HMSRoomModel(roomCode: roomCode, options: options?.roomOptions) { sdk in
            sdk.frameworkInfo = HMSFrameworkInfo(isPrebuilt: true)
        }
        
        self.roomCode = roomCode
        self.onDismiss = onDismiss
        self.options = options ?? HMSPrebuiltOptions()
    }
    
    @State var isLayoutLoaded = false
    
    public var body: some View {
        
        Group {
            if isLayoutLoaded {
                HMSPrebuiltMeetingView(onDismiss: onDismiss)
                    .environmentObject(roomModel)
                    .environmentObject(roomInfoModel)
                    .environmentObject(options)
            }
            else {
                HMSLoadingScreen()
            }
        }
        .environmentObject(options.theme ?? roomInfoModel.theme)
        .task {
            // Call layout API

            do {
                let roomLayout = try await roomModel.getRoomLayout()
                roomInfoModel.roomLayout = roomLayout
            }
            catch {
                assertionFailure(error.localizedDescription)
            }
            
            isLayoutLoaded = true
        }
    }
}

struct HMSRoomView_Previews: PreviewProvider {
    static var previews: some View {
        HMSPrebuiltView(roomCode: "qdw-mil-sev")
    }
}

public extension HMSPrebuiltView {
    
    func themeOverride(_ builder: (HMSUITheme)->Void) -> HMSPrebuiltView {
        let theme = HMSUITheme()
        builder(theme)
        let options = self.options
        options.theme = theme
        return HMSPrebuiltView(roomCode: self.roomCode, options: options, onDismiss: self.onDismiss)
    }
    
    func screenShare(appGroupName: String, preferredExtensionName: String) -> HMSPrebuiltView {
        let options = self.options
        options.roomOptions = HMSRoomOptions(appGroupName: appGroupName)
        options.preferredExtensionName = preferredExtensionName
        return HMSPrebuiltView(roomCode: self.roomCode, options: options, onDismiss: self.onDismiss)
    }
}
