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
    
    @State var isMaximized = false
    
    var body: some View {
        
        ZStack {
            
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { reader in
                
                if #available(iOS 16.0, *) {
                    
                    let layout = verticalSizeClass == .compact ? AnyLayout(HStackLayout())
                    : AnyLayout(VStackLayout())
                    
                    layout {
                        HMSHLSViewerScreen(isMaximized: $isMaximized)
                            .frame(height: !isMaximized && verticalSizeClass == .regular ? (reader.size.width * 9)/16 : nil)

                        if !isMaximized {
                            
                            if verticalSizeClass == .regular {
                                chatScreen
                            }
                            else {
                                chatScreen
                                    .frame(width: reader.size.width/2.5)
                            }
                        }
                    }
                }
                else {
                    if verticalSizeClass == .regular {
                        VStack {
                            HMSHLSViewerScreen(isMaximized: $isMaximized)
                                .frame(height: !isMaximized ? (reader.size.width * 9)/16 : nil)

                            if !isMaximized {
                                chatScreen
                            }
                        }
                    }
                    else {
                        HStack(spacing: 0) {
                            HMSHLSViewerScreen(isMaximized: $isMaximized)
                            
                            if !isMaximized {
                                chatScreen
                                    .frame(width: reader.size.width/2.5)
                            }
                        }
                    }
                }
            }
        }
        .background(.backgroundDim, cornerRadius: 0)
    }
    
    @Environment(\.keyboardState) var keyboardState
    @EnvironmentObject var roomKitModel: HMSRoomNotificationModel
    
    let descriptionTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State var streamStartedText: String = ""
    
    @ViewBuilder
    var descriptionPane: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HMSCompanyLogoView()
                VStack {
                    HStack {
                        Text("\(roomModel.participantCountDisplayString) watching").lineLimit(1).font(.captionRegular12)
                            .foreground(.onSurfaceMedium).layoutPriority(2)
                        if !streamStartedText.isEmpty {
                            Text("·").font(.captionRegular12)
                                .foreground(.onSurfaceMedium)
                            Text("Started \(streamStartedText) ago").lineLimit(1).font(.captionRegular12)
                                .foreground(.onSurfaceMedium).layoutPriority(1)
                        }
                        if roomModel.recordingState == .recording {
                            Text("·").font(.captionRegular12)
                                .foreground(.onSurfaceMedium)
                            Text("Recording").lineLimit(1).truncationMode(.tail).font(.captionRegular12)
                                .foreground(.onSurfaceMedium)
                        }
                        Spacer()
                    }
                }
            }.padding(16)
            HMSDivider(color: currentTheme.colorTheme.borderBright)
        }
        .background(.surfaceDim, cornerRadius: 0, ignoringEdges: .all)
        .onReceive(descriptionTimer) { time in
            refreshStreamStartedText()
        }.onAppear() {
            refreshStreamStartedText()
        }
    }
    
    @ViewBuilder
    var chatScreen: some View {
        
        let isParticipantListEnabled = conferenceComponentParam.participantList != nil
        let isBrbEnabled = conferenceComponentParam.brb != nil
        let isHandRaiseEnabled = conferenceComponentParam.onStageExperience != nil
        let canStartRecording = roomModel.userCanStartStopRecording
        let canScreenShare = roomModel.userCanShareScreen
        
        VStack(spacing: 0) {
            
            if keyboardState.wrappedValue == .hidden {
                descriptionPane
            }
            
            HStack {
                HMSChatScreen(content: {
                    
                    if let localPeerModel = roomModel.localPeerModel {
                        
                        HMSHandRaisedToggle()
                            .environmentObject(localPeerModel)
                        
                        if isParticipantListEnabled || isBrbEnabled || isHandRaiseEnabled || canStartRecording || canScreenShare {
                            HMSOptionsToggleView(isHLSViewer: true)
                        }
                    }
                }) {
                    if keyboardState.wrappedValue == .hidden {
                        HMSNotificationStackView()
                            .padding([.bottom], 8)
                    }
                }
                .environment(\.chatScreenAppearance, .constant(.init(pinnedMessagePosition: .bottom)))
            }
        }
    }
    
    var topBarGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.64), currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.0)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private func refreshStreamStartedText() {
        if let variant = roomModel.hlsVariants.first,
           let startedAt = variant.startedAt {
            streamStartedText = startedAt.minutesSinceNow
        }
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
            .environmentObject(HMSRoomNotificationModel())
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
