//
//  HMSRoomView.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 29/05/2023.
//

import SwiftUI
import HMSSDK
import Combine
import HMSRoomModels

public struct HMSPrebuiltView: View {
    
    @StateObject var roomInfoModel = HMSRoomInfoModel()
    
    let roomCode: String?
    let token: String?
    let onDismiss: (() -> Void)?
    let options: HMSPrebuiltOptions
    
    let roomModel: HMSRoomModel
    
    public init(roomCode: String, options: HMSPrebuiltOptions? = nil, onDismiss: (() -> Void)? = nil) {
        
        roomModel = HMSRoomModel(roomCode: roomCode, options: options?.roomOptions) { sdk, audioSettingsBuilder, videoSettingsBuilder in
            
            sdk.frameworkInfo = HMSFrameworkInfo(isPrebuilt: true)
            videoSettingsBuilder.initialMuteState = .mute
            audioSettingsBuilder.initialMuteState = .mute
        }
        
        if let userName = options?.roomOptions?.userName {
            roomModel.userName = userName
        }
        
        self.roomCode = roomCode
        self.token = nil
        self.onDismiss = onDismiss
        self.options = options ?? HMSPrebuiltOptions()
    }
    
    public init(token: String, options: HMSPrebuiltOptions? = nil, onDismiss: (() -> Void)? = nil) {
        
        roomModel = HMSRoomModel(token: token, options: options?.roomOptions) { sdk, audioSettingsBuilder, videoSettingsBuilder  in
            
            sdk.frameworkInfo = HMSFrameworkInfo(isPrebuilt: true)
            videoSettingsBuilder.initialMuteState = .mute
            audioSettingsBuilder.initialMuteState = .mute
        }
        
        if let userName = options?.roomOptions?.userName {
            roomModel.userName = userName
        }
        
        self.token = token
        self.roomCode = nil
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
                    .environmentObject(options.roomOptions ?? .init())
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
        if let token = token {
            return HMSPrebuiltView(token: token, options: options, onDismiss: self.onDismiss)
        }
        else {
            // room code must be there if token is nil - our inits make sure of that
            return HMSPrebuiltView(roomCode: self.roomCode!, options: options, onDismiss: self.onDismiss)
        }
    }
    
    func screenShare(appGroupName: String, screenShareBroadcastExtensionBundleId: String) -> HMSPrebuiltView {
        let options = self.options
        options.roomOptions = HMSRoomOptions(userName: options.roomOptions?.userName, userId: options.roomOptions?.userId, appGroupName: appGroupName, screenShareBroadcastExtensionBundleId: screenShareBroadcastExtensionBundleId, noiseCancellation: self.options.roomOptions?.noiseCancellation, virtualBackground: options.roomOptions?.virtualBackground)
        
        if let token = token {
            return HMSPrebuiltView(token: token, options: options, onDismiss: self.onDismiss)
        }
        else {
            // room code must be there if token is nil - our inits make sure of that
            return HMSPrebuiltView(roomCode: self.roomCode!, options: options, onDismiss: self.onDismiss)
        }
    }
    
    func noiseCancellation(model: String, initialState: HMSNoiseCancellationInitialState) -> HMSPrebuiltView {
        let options = self.options
        options.roomOptions = HMSRoomOptions(userName: options.roomOptions?.userName, userId: options.roomOptions?.userId, appGroupName: options.roomOptions?.appGroupName, screenShareBroadcastExtensionBundleId: options.roomOptions?.screenShareBroadcastExtensionBundleId, noiseCancellation: .init(with: model, initialState: initialState), virtualBackground: options.roomOptions?.virtualBackground)
        
        if let token = token {
            return HMSPrebuiltView(token: token, options: options, onDismiss: self.onDismiss)
        }
        else {
            // room code must be there if token is nil - our inits make sure of that
            return HMSPrebuiltView(roomCode: self.roomCode!, options: options, onDismiss: self.onDismiss)
        }
    }
}
