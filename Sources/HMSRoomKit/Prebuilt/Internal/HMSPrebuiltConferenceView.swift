//
//  HMSPrebuiltConferenceView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 11/1/23.
//

import SwiftUI
import HMSRoomModels

struct HMSPrebuiltConferenceView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var roomInfoModel: HMSRoomInfoModel
    
    @StateObject var pollModel = HMSRoomKitPollModel()
    
    @State var isPollViewPresented = false
    @State var isPollCreationViewPresented = false
    
    var body: some View {
        ZStack {
            HMSConferenceScreen {
                switch roomInfoModel.conferencingType {
                case .default:
                    return .default { screen in
                        if let defaultScreen = roomInfoModel.defaultConferencingScreen {
                            
                            if let chat = defaultScreen.elements?.chat {
                                screen.chat = .init(initialState: chat.initial_state == .CHAT_STATE_OPEN ? .open : .close, isOverlay: chat.is_overlay , allowsPinningMessages: chat.allow_pinning_messages )
                            }
                            else {
                                screen.chat = nil
                            }
                            
                            if let tileLayout = defaultScreen.elements?.video_tile_layout?.grid {
                                screen.tileLayout = .init(grid: .init(isLocalTileInsetEnabled: tileLayout.enable_local_tile_inset , prominentRoles: tileLayout.prominent_roles , canSpotlightParticipant: tileLayout.enable_spotlighting_peer ))
                            }
                            else {
                                screen.tileLayout = nil
                            }
                            
                            if let on_stage_exp = defaultScreen.elements?.on_stage_exp {
                                screen.onStageExperience = .init(onStageRoleName: on_stage_exp.on_stage_role, rolesWhoCanComeOnStage: on_stage_exp.off_stage_roles, bringToStageLabel: on_stage_exp.bring_to_stage_label, removeFromStageLabel: on_stage_exp.remove_from_stage_label)
                            }
                            else {
                                screen.onStageExperience = nil
                            }
                            
                            if (defaultScreen.elements?.brb) != nil {
                                screen.brb = .init()
                            }
                            else {
                                screen.brb = nil
                            }
                            
                            if (defaultScreen.elements?.participant_list) != nil {
                                screen.participantList = .init()
                            }
                            else {
                                screen.participantList = nil
                            }
                        }
                    }
                case .liveStreaming:
                    return .liveStreaming { screen in
                        if let defaultScreen = roomInfoModel.liveStreamingConferencingScreen {
                            
                            if let chat = defaultScreen.elements?.chat {
                                screen.chat = .init(initialState: chat.initial_state == .CHAT_STATE_OPEN ? .open : .close, isOverlay: chat.is_overlay , allowsPinningMessages: chat.allow_pinning_messages )
                            }
                            else {
                                screen.chat = nil
                            }
                            
                            if let tileLayout = defaultScreen.elements?.video_tile_layout?.grid {
                                screen.tileLayout = .init(grid: .init(isLocalTileInsetEnabled: tileLayout.enable_local_tile_inset , prominentRoles: tileLayout.prominent_roles , canSpotlightParticipant: tileLayout.enable_spotlighting_peer ))
                            }
                            else {
                                screen.tileLayout = nil
                            }
                            
                            if let on_stage_exp = defaultScreen.elements?.on_stage_exp {
                                screen.onStageExperience = .init(onStageRoleName: on_stage_exp.on_stage_role, rolesWhoCanComeOnStage: on_stage_exp.off_stage_roles, bringToStageLabel: on_stage_exp.bring_to_stage_label, removeFromStageLabel: on_stage_exp.remove_from_stage_label)
                            }
                            else {
                                screen.onStageExperience = nil
                            }
                            
                            if (defaultScreen.elements?.brb) != nil {
                                screen.brb = .init()
                            }
                            else {
                                screen.brb = nil
                            }
                            
                            if (defaultScreen.elements?.participant_list) != nil {
                                screen.participantList = .init()
                            }
                            else {
                                screen.participantList = nil
                            }
                        }
                    }
                }
            }
            .onAppear() {
                UIApplication.shared.isIdleTimerDisabled = true
            }
#if !Preview
            .onAppear() {
                pollModel.roomModel = roomModel
                pollModel.beginListeningForPolls()
            }
            .overlay(alignment: .bottom) {
                
                HStack {
                    if !pollModel.isPollViewHidden {
                        Text("View Poll")
                            .foregroundStyle(.white)
                            .onTapGesture {
                                guard let _ = roomModel.interactivityCenter.polls.last(where: { $0.state == .started }),
                                      let _ = roomModel.localPeerModel?.peer.role else { return }
                                isPollViewPresented.toggle()
                            }
                    }
                    
                    Text("Create Poll")
                        .foregroundStyle(.white)
                        .onTapGesture {
                            guard let _ = roomModel.localPeerModel?.role else { return }
                            isPollCreationViewPresented.toggle()
                        }
                }
            }
            .sheet(isPresented: $isPollViewPresented, content: {
                let center = roomModel.interactivityCenter
                if let poll = center.polls.last(where: { $0.state == .started }), let role = roomModel.localPeerModel?.peer.role {
                    let model = PollVoteViewModel(poll: poll, interactivityCenter: center, currentRole: role, peerList: roomModel.room?.peers ?? [])
                    PollVoteView(model: model)
                }
            })
            .sheet(isPresented: $isPollCreationViewPresented, content: {
                let center = roomModel.interactivityCenter
                if let role = roomModel.localPeerModel?.role {
                    let pollAdminRoles = roomModel.roles.filter({ $0.name == "host" || $0.name == "teacher" })
                    let model = PollCreateModel(interactivityCenter: center, limitViewResultsToRoles: pollAdminRoles, currentRole: role)
                    PollCreateView(model: model)
                }
            })
#endif
            if !roomModel.roleChangeRequests.isEmpty {
                HMSPreviewRoleScreen()
            }
        }
    }
}

struct HMSPrebuiltConferenceView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPrebuiltConferenceView()
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
