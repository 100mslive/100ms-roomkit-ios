//
//  HMSPreviewTopOverlay.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 21/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import Combine

import HMSSDK
import HMSRoomModels

struct HMSPreviewBottomOverlay: View {
    
    @Environment(\.previewComponentParam) var previewComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @State var showDeviceSettings = false
    @State private var cancellable: AnyCancellable?
    
    @Binding var isStartingStream: Bool
    
    @State var isJoining = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                
                if roomModel.previewAudioTrack != nil {
                    HMSMicToggle()
                }
                
                if roomModel.previewVideoTrack != nil {
                    HMSCameraToggle()
                    HMSSwitchCameraButton()
                }
                
                Spacer()
                HMSAirplayButton {
                    HMSSpeakerButtonView()
                }
//                .sheet(isPresented: $showDeviceSettings) {
//                    HalfSheet {
//                        HMSDeviceSettingsSheetView(isPresented: $showDeviceSettings)
//                            .environmentObject(currentTheme)
//                            .environmentObject(roomModel)
//                    }
//                    .edgesIgnoringSafeArea(.all)
//                }
//                .onTapGesture {
//                    showDeviceSettings.toggle()
//                }
            }

            HStack {
                HMSJoinNameLabel()
                    .onTapGesture {
                        // it's here to stop keyboard dismissal by tapping text field
                    }
                HMSJoinButton(isJoining: $isJoining)
                    .onTapGesture {
#if !Preview
                        guard !roomModel.userName.isEmpty else { return }
                        
                        Task {
                            
                            isJoining = true
                            try await roomModel.join(userName: roomModel.userName)
                            isJoining = false
                            
                            if previewComponentParam.joinButtonType == .goLive && !roomModel.isBeingStreamed {
                                
                                isStartingStream = true
                                
                                cancellable = roomModel.$isBeingStreamed.dropFirst().sink { isBeingStreamed in
                                    if isBeingStreamed {
                                        isStartingStream = false
                                        roomModel.roomState = .meeting
                                    }
                                    cancellable = nil
                                }
                                do {
                                    try await roomModel.startStreaming()
                                    if roomModel.isBeingStreamed {
                                        roomModel.roomState = .meeting
                                    }
                                } catch {
                                    isStartingStream = false
                                    cancellable = nil
                                    try await roomModel.leave()
                                }
                            }
                            else {
                                roomModel.roomState = .meeting
                            }
                        }
#endif
                    }
            }
        }
        .padding(16)
        .background(.backgroundDefault, cornerRadius: 16, corners: [.topLeft, .topRight], ignoringEdges: .all)
    }
}

struct HMSPreviewBottomOverlay_Previews: PreviewProvider {
    
    static var previews: some View {
#if Preview
        @State var isStartingStream = false
        
        HMSPreviewBottomOverlay(isStartingStream: $isStartingStream)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
