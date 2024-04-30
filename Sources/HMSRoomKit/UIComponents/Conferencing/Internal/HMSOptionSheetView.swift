//
//  HMSOptionSheetView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 03/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSOptionSheetView: View {
    
    @Environment(\.captionsState) var captionsState
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.pollsOptionAppearance) var pollsOptionAppearance
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    enum Sheet: String, Identifiable {
        case chat
        case participants
        case stopRecording
        var id: String { rawValue }
    }
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var localPeerModel: HMSPeerModel
    @State var internalSheet: Sheet?
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.hlsPlaybackQuality) var hlsPlaybackQuality
    
    let isHLSViewer: Bool
    
    @EnvironmentObject var roomKitModel: HMSRoomNotificationModel
    
    var body: some View {
        
        let isParticipantListEnabled = conferenceComponentParam.participantList != nil
        let isBrbEnabled = conferenceComponentParam.brb != nil
        let isHandRaiseEnabled = conferenceComponentParam.isHandRaiseEnabled
        
        VStack(spacing: 0) {
            HMSOptionsHeaderView(title: "Options", onClose: {
                dismiss()
            })
            HStack {
                Spacer(minLength: 0)
                
                LazyVGrid(columns: verticalSizeClass == .regular ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    
                    if isParticipantListEnabled {
                        HMSSessionMenuButton(text: "Participants", image: "group", highlighted: false, badgeText: roomModel.viewerCountDisplayString).onTapGesture {
                            internalSheet = .participants
                        }
                    }
                    
                    if roomModel.userCanShareScreen {
                        HMSShareScreenButton(onTap: {
                            dismiss()
                        }) {
                            HMSSessionMenuButton(text: localPeerModel.isSharingScreen ? "Stop Sharing Screen" : "Share Screen", image: "screenshare-icon", highlighted: localPeerModel.isSharingScreen)
                        }
                    }
                    
                    if isBrbEnabled {
                        HMSSessionMenuButton(text: localPeerModel.status == .beRightBack ? "Cancel Be Right Back" : "Be Right Back", image: "brb-icon", highlighted: localPeerModel.status == .beRightBack)
                            .onTapGesture {
                                Task {
                                    try await
                                    roomModel.setUserStatus(localPeerModel.status == .beRightBack ? .none : .beRightBack)
                                }
                                dismiss()
                            }
                    }
                    
                    if isHandRaiseEnabled {
                        HMSSessionMenuButton(text: localPeerModel.status == .handRaised ? "Lower Hand" : "Raise Hand", image: "hand-raise-icon", highlighted: localPeerModel.status == .handRaised)
                            .onTapGesture {
                                Task {
                                    try await roomModel.setUserStatus(localPeerModel.status == .handRaised ? .none : .handRaised)
                                }
                                dismiss()
                            }
                    }
                    
                    if roomModel.userCanStartStopRecording {
                        HMSSessionMenuButton(text: roomModel.recordingState != .stopped ? "Recording On" : "Start Recording", image: "record-on", highlighted: roomModel.recordingState != .stopped, isDisabled: isHLSViewer)
                            .onTapGesture {
                                guard roomModel.recordingState == .stopped else {
                                    internalSheet = .stopRecording
                                    return
                                }
                                
                                Task {
                                    try await roomModel.startRecording()
                                }
                                dismiss()
                            }
                    }
                    
                    if ((roomModel.userRole?.permissions.pollWrite ?? false)) {
                        
                        HMSSessionMenuButton(text: "Polls and Quizzes", image: "poll-vote", highlighted: pollsOptionAppearance.containsItems.wrappedValue, isDisabled: false)
                            .onTapGesture {
                                NotificationCenter.default.post(name: .init(rawValue: "poll-create"), object: nil)
                                
                                pollsOptionAppearance.badgeState.wrappedValue = .none
                                
                                dismiss()
                            }
                        
                    }
                    else if (roomModel.userRole?.permissions.pollRead ?? false) {
                        
                        if pollsOptionAppearance.containsItems.wrappedValue {
                            
                            HMSSessionMenuButton(text: "Polls and Quizzes", image: "poll-vote", highlighted: true, isDisabled: false)
                                .onTapGesture {
                                    NotificationCenter.default.post(name: .init(rawValue: "poll-view"), object: nil)
                                    
                                    pollsOptionAppearance.badgeState.wrappedValue = .none
                                    
                                    dismiss()
                                }
                        }
                    }
                    
                    if roomModel.localAudioTrackModel != nil, roomModel.isNoiseCancellationAvailable {
                        HMSSessionMenuButton(text: roomModel.isNoiseCancellationEnabled ? "Noise Reduced" : "Reduce Noise", image: "noise-cancellation", highlighted: (roomModel.isNoiseCancellationEnabled))
                            .onTapGesture {
                                try? roomModel.toggleNoiseCancellation()
                                dismiss()
                            }
                    }
                    
                    if roomModel.isWhiteboardAvailable && roomModel.userWhiteboardPermissions.contains(.admin) {
                        HMSSessionMenuButton(text: roomModel.whiteboard != nil ? "Close Whiteboard" : "Open Whiteboard", image: "whiteboard-icon", highlighted: false, isDisabled: roomModel.whiteboard != nil && roomModel.whiteboard?.owner != localPeerModel.peer)
                            .onTapGesture {
                                
                                guard !(roomModel.whiteboard != nil && roomModel.whiteboard?.owner != localPeerModel.peer) else { return }
                                
                                if roomModel.peersSharingScreen.count > 0 {
                                    roomKitModel.addNotification(HMSRoomKitNotification(id: "", type: .warning(icon: "whiteboard-icon"), actor: "", isDismissible: true, title: "Discontinue screenshare to open the whiteboard"))
                                    
                                    dismiss()
                                }
                                else {
                                    
                                    Task {
                                        if roomModel.whiteboard != nil {
                                            try? await roomModel.stopWhiteboard()
                                        }
                                        else {
                                            try? await roomModel.startWhiteboard()
                                        }
                                        dismiss()
                                    }
                                }
                            }
                    }
                    
                    if roomModel.isTranscriptionAvailable {
                        
                        HMSSessionMenuButton(text: captionsState.wrappedValue == .visible ? "Hide Captions" : "Show Captions", image: "captions-icon", highlighted: captionsState.wrappedValue == .visible)
                            .onTapGesture {
                                captionsState.wrappedValue = captionsState.wrappedValue == .visible ? .hidden : .visible
                                dismiss()
                            }
                    }
                }
                .padding(.bottom)
            }
        }
        .foreground(.onSurfaceHigh)
        .sheet(item: $internalSheet) { sheet in
            switch sheet {
            case .participants:
                if #available(iOS 16.0, *) {
                    HMSChatParticipantToggleView(initialPane: .participants).presentationDetents([.large])
                } else {
                    HMSChatParticipantToggleView(initialPane: .participants)
                }
            
            case .chat:
                if #available(iOS 16.0, *) {
                    HMSChatParticipantToggleView().presentationDetents([.large])
                } else {
                    HMSChatParticipantToggleView()
                }
            case .stopRecording:
                HMSSheet {
                    if verticalSizeClass == .regular {
                        HMSStopRecordingView()
                    }
                    else {
                        ScrollView {
                            HMSStopRecordingView()
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct HMSOptionSheetView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSOptionSheetView(isHLSViewer: true)
            .background(.black)
            .environmentObject(HMSRoomModel.localPeer)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
