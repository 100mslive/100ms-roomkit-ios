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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        let isParticipantListEnabled = conferenceComponentParam.participantList != nil
        let isBrbEnabled = conferenceComponentParam.brb != nil
        let isHandRaiseEnabled = conferenceComponentParam.onStageExperience != nil
        
        VStack(spacing: 0) {
            HMSOptionsHeaderView(title: "Options", onClose: {
                presentationMode.wrappedValue.dismiss()
            })
            HStack {
                Spacer(minLength: 0)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    
                    if isParticipantListEnabled {
                        HMSSessionMenuButton(text: "Participants", image: "group", highlighted: false, badgeText: "\(roomModel.peerModels.count)").onTapGesture {
                            internalSheet = .participants
                        }
                    }
                    
                    if roomModel.userCanShareScreen {
                        HMSShareScreenButton(onTap: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HMSSessionMenuButton(text: localPeerModel.isSharingScreen ? "Stop Sharing Screen" : "Share Screen", image: "screenshare-icon", highlighted: localPeerModel.isSharingScreen)
                        }
                    }
                    
                    if isBrbEnabled {
                        HMSSessionMenuButton(text: localPeerModel.status == .beRightBack ? "Cancel Be Right Back" : "Be Right Back", image: "brb-icon", highlighted: localPeerModel.status == .beRightBack)
                            .onTapGesture {
                                roomModel.setUserStatus(localPeerModel.status == .beRightBack ? .none : .beRightBack)
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    
                    if isHandRaiseEnabled {
                        HMSSessionMenuButton(text: localPeerModel.status == .handRaised ? "Lower Hand" : "Raise Hand", image: "hand-raise-icon", highlighted: localPeerModel.status == .handRaised)
                            .onTapGesture {
                                roomModel.setUserStatus(localPeerModel.status == .handRaised ? .none : .handRaised)
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    
                    if roomModel.userCanStartStopRecording {
                        HMSSessionMenuButton(text: roomModel.recordingState != .stopped ? "Recording On" : "Start Recording", image: "record-on", highlighted: roomModel.recordingState != .stopped, isDisabled: roomModel.isUserHLSViewer)
                            .onTapGesture {
                                guard roomModel.recordingState == .stopped else {
                                    internalSheet = .stopRecording
                                    return
                                }
                                
                                Task {
                                    try await roomModel.startRecording()
                                }
                                presentationMode.wrappedValue.dismiss()
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
                    HMSStopRecordingView()
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct HMSOptionSheetView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSOptionSheetView()
            .background(.black)
            .environmentObject(HMSRoomModel.localPeer)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
