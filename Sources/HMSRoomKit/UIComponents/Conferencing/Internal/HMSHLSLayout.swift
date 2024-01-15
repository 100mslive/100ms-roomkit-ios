//
//  HMSHLSLayout.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 1/15/24.
//

import SwiftUI
import HMSRoomModels

struct HMSHLSLayout: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @Environment(\.controlsState) var controlsState
    
    var body: some View {
        ZStack {
            
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { reader in
                if verticalSizeClass == .regular {
                    VStack {
                        HMSHLSViewerScreen()
                            .frame(height: reader.size.height/3)
                        chatScreen
                    }
                }
                else {
                    HStack(spacing: 0) {
                        HMSHLSViewerScreen()
                        chatScreen
                            .frame(width: reader.size.width/2.2)
                    }
                }
            }
        }
        .background(.backgroundDim, cornerRadius: 0)
    }
    
    @ViewBuilder
    var chatScreen: some View {
        
        let isParticipantListEnabled = conferenceComponentParam.participantList != nil
        let isBrbEnabled = conferenceComponentParam.brb != nil
        let isHandRaiseEnabled = conferenceComponentParam.onStageExperience != nil
        let canStartRecording = roomModel.userCanStartStopRecording
        let canScreenShare = roomModel.userCanShareScreen
        
        HStack {
            HMSChatScreen {
                if let localPeerModel = roomModel.localPeerModel {
                    HMSHandRaisedToggle()
                        .environmentObject(localPeerModel)
                    
                    if isParticipantListEnabled || isBrbEnabled || isHandRaiseEnabled || canStartRecording || canScreenShare {
                        HMSOptionsToggleView(isHLSViewer: true)
                    }
                }
            }
            .environment(\.chatScreenAppearance, .constant(.init(pinnedMessagePosition: .bottom)))
        }
    }
    
    var topBarGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.64), currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.0)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct HMSHLSLayout_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSLayout()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2, [.prominent, .prominent]))
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomInfoModel())
#endif
    }
}


//                    .edgesIgnoringSafeArea(.all)
//                .overlay(alignment: .top) {
//                    HMSTopControlStrip()
//                        .padding([.bottom,.horizontal], 16)
//                        .transition(.move(edge: .top))
//                        .background (
//                            topBarGradient
//                                .edgesIgnoringSafeArea(.all)
//                        )
//                        .frame(height: controlsState.wrappedValue == .hidden ? 0 : nil)
//                        .opacity(controlsState.wrappedValue == .hidden ? 0 : 1)
//                }
