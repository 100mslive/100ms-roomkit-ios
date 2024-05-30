//
//  HMSPrebuiltConferenceView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 11/1/23.
//

import SwiftUI
import HMSRoomModels
import HMSSDK

extension [PollVoteViewModel]: Identifiable {
    public var id: Int {
        self.count
    }
}

struct HMSPrebuiltConferenceView: View {
    static let hlsCueDuration = 20
    
    @Environment(\.pollsOptionAppearance) var pollsOptionAppearance
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var roomInfoModel: HMSRoomInfoModel
    @StateObject var roomKitModel = HMSRoomNotificationModel()
    
    @EnvironmentObject var pollModel: HMSRoomKitPollModel
    
    @State var pollVoteViewModel: PollVoteViewModel? = nil
    @State var pollCreateModel: PollCreateModel? = nil
    
    @State var pollVoteViewModels: [PollVoteViewModel]? = nil
    @State var hlsPollIDs = [String]()
    
    @State var previousTranscriptionStates: [HMSTranscriptionState]?
    
    var body: some View {
        ZStack {
            HMSConferenceScreen {
                switch roomInfoModel.conferencingType {
                case .default:
                    return .default { screen in
                        if let defaultScreen = roomInfoModel.defaultConferencingScreen {
                            
                            if let chat = defaultScreen.elements?.chat {
                                
                                var chatScopes = [HMSConferenceScreen.DefaultType.Chat.Scope]()
                                
                                if chat.public_chat_enabled {
                                    chatScopes.append(.public)
                                }
                                
                                if !chat.roles_whitelist.isEmpty {
                                    chatScopes.append(.roles(whiteList: chat.roles_whitelist))
                                }
                                
                                if chat.private_chat_enabled {
                                    chatScopes.append(.private)
                                }
                                
                                screen.chat = .init(initialState: chat.initial_state == .CHAT_STATE_OPEN ? .open : .close, isOverlay: chat.is_overlay, allowsPinningMessages: chat.allow_pinning_messages, title: chat.chat_title, messagePlaceholder: chat.message_placeholder, chatScopes: chatScopes, controls: .init(canDisableChat: chat.real_time_controls?.can_disable_chat ?? false, canBlockUser: chat.real_time_controls?.can_block_user ?? false, canHideMessage: chat.real_time_controls?.can_hide_message ?? false))
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
                                screen.onStageExperience = .init(onStageRoleName: on_stage_exp.on_stage_role, rolesWhoCanComeOnStage: on_stage_exp.off_stage_roles, bringToStageLabel: on_stage_exp.bring_to_stage_label, removeFromStageLabel: on_stage_exp.remove_from_stage_label, skipPreviewForRoleChange: on_stage_exp.skip_preview_for_role_change)
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
                            
                            screen.isHandRaiseEnabled = defaultScreen.elements?.hand_raise != nil
                            
                            if let header = defaultScreen.elements?.header {
                                screen.header = .init(title: header.title, description: header.description)
                            }
                            else {
                                screen.header = nil
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
                                
                                var chatScopes = [HMSConferenceScreen.DefaultType.Chat.Scope]()
                                
                                if chat.public_chat_enabled {
                                    chatScopes.append(.public)
                                }
                                
                                if !chat.roles_whitelist.isEmpty {
                                    chatScopes.append(.roles(whiteList: chat.roles_whitelist))
                                }
                                
                                if chat.private_chat_enabled {
                                    chatScopes.append(.private)
                                }
                                
                                screen.chat = .init(initialState: chat.initial_state == .CHAT_STATE_OPEN ? .open : .close, isOverlay: chat.is_overlay, allowsPinningMessages: chat.allow_pinning_messages, title: chat.chat_title, messagePlaceholder: chat.message_placeholder, chatScopes: chatScopes, controls: .init(canDisableChat: chat.real_time_controls?.can_disable_chat ?? false, canBlockUser: chat.real_time_controls?.can_block_user ?? false, canHideMessage: chat.real_time_controls?.can_hide_message ?? false))
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
                                screen.onStageExperience = .init(onStageRoleName: on_stage_exp.on_stage_role, rolesWhoCanComeOnStage: on_stage_exp.off_stage_roles, bringToStageLabel: on_stage_exp.bring_to_stage_label, removeFromStageLabel: on_stage_exp.remove_from_stage_label, skipPreviewForRoleChange: on_stage_exp.skip_preview_for_role_change)
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
                            
                            screen.isHandRaiseEnabled = defaultScreen.elements?.hand_raise != nil
                            
                            if let header = defaultScreen.elements?.header {
                                screen.header = .init(title: header.title, description: header.description)
                            }
                            else {
                                screen.header = nil
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
            .environmentObject(roomKitModel)
            .onAppear() {
                UIApplication.shared.isIdleTimerDisabled = true
                updatePollNotifications()
            }
#if !Preview
            .onChange(of: pollModel.currentPolls) { _ in
                updatePollNotifications()
            }
            .onAppear() {
                previousTranscriptionStates = roomModel.transcriptionStates
            }
            .onChange(of: roomModel.transcriptionStates) { newTranscriptionStates in
                
                guard let newCaptionState = newTranscriptionStates.stateWith(mode: .caption) else { return }
                let prevCaptionState = previousTranscriptionStates?.stateWith(mode: .caption)
                
                if newCaptionState != prevCaptionState {
                    
                    if newCaptionState.state == .failed {
                        roomKitModel.addNotification(HMSRoomKitNotification(id: UUID().uuidString, type: .error(icon: "warning-icon", retry: false, isTerminal: false), actor: "", isDismissible: true, title: "Failed to enable Closed Captions"))
                    }
                    else if newCaptionState.state == .started {
                        let note = HMSRoomKitNotification(id: UUID().uuidString, type: .closedCaptionStatus(icon: "captions-highlighted"), actor: "", isDismissible: false, title: "Closed Captioning enabled for everyone")
                        roomKitModel.addNotification(note)
                        Task {
                            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                            roomKitModel.removeNotification(for: [note.id])
                        }
                    }
                    else if newCaptionState.state == .stopped {
                        let note = HMSRoomKitNotification(id: UUID().uuidString, type: .closedCaptionStatus(icon: "captions-icon"), actor: "", isDismissible: false, title: "Closed Captioning disabled for everyone")
                        roomKitModel.addNotification(note)
                        Task {
                            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                            roomKitModel.removeNotification(for: [note.id])
                        }
                    }
                    
                    previousTranscriptionStates = newTranscriptionStates
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .init(rawValue: "poll-vote"))) { notification in
                let center = roomModel.interactivityCenter
                guard let pollIdOfInterest: String = notification.object as? String else { return }
                if let poll = center.polls.first(where: { $0.pollID == pollIdOfInterest }), let role = roomModel.localPeerModel?.peer.role {
                    
                    pollVoteViewModel = PollVoteViewModel(poll: poll, interactivityCenter: center, currentRole: role, peerList: roomModel.room?.peers ?? [])
                    let isAdmin = role.permissions.pollWrite ?? false
                    pollVoteViewModel?.isAdmin = isAdmin
                    pollVoteViewModel?.canEndPoll = isAdmin && poll.state == .started
                    
                    roomKitModel.dismissNotification(for: pollIdOfInterest)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .init(rawValue: "poll-create"))) { _ in
                setupPollCreateModel()
            }
            .onReceive(NotificationCenter.default.publisher(for: .init(rawValue: "poll-hls-cue"))) { notification in
                if let pollID = notification.userInfo?["pollID"] as? String {
                    hlsPollIDs.append(pollID)
                }
                updatePollNotifications()
            }
            .onReceive(NotificationCenter.default.publisher(for: .init(rawValue: "poll-view"))) { notification in
                setupPollCreateModel()
            }
            .sheet(item: $pollVoteViewModel, content: { model in
                NavigationView {
                    PollVoteView(model: model)
                }
            })
            .sheet(item: $pollCreateModel, content: { model in
                PollCreateView(model: model)
            })
            .sheet(item: $pollVoteViewModels, content: { models in
                ScrollView {
                    ForEach(models) { model in
                        PollVoteView(model: model)
                    }
                    .padding(.bottom, 30)
                }
                .background(HMSUIColorTheme().surfaceDefault)
            })
#endif
            if !roomModel.roleChangeRequests.isEmpty {
                HMSPreviewRoleScreen()
            }
        }
    }
    
    func updatePollNotifications() {
        let isHLSViewer = (roomInfoModel.conferencingType == .liveStreaming)
        let existingPollNotificationIds = roomKitModel.notifications.filter {
            if case .poll(_) = $0.type {
                return true
            }
            else {
                return false
            }
        }.map{$0.id}
        
        let currentPolls = pollModel.currentPolls.filter { poll in
            guard isHLSViewer else { return true }
           
            // Poll is older than hls rolling window so assume timed metadata cue will not come
            if let startedAt = poll.startedAt, Date().timeIntervalSince(startedAt) >= TimeInterval(HMSPrebuiltConferenceView.hlsCueDuration) {
                return true
            }
            // Cue has come with poll ID show matching poll
            else if hlsPollIDs.contains(poll.pollID) {
                return true
            }
            
            return false
        }
        
        let newPolls = currentPolls.filter { poll in
            !existingPollNotificationIds.contains(poll.pollID)
        }
        
        let pollsThatAreStopped = existingPollNotificationIds.filter{!pollModel.currentPolls.map{$0.pollID}.contains($0)}
        
        roomKitModel.removeNotification(for: pollsThatAreStopped)
        
        guard (roomModel.userRole?.permissions.pollRead ?? false) || (roomModel.userRole?.permissions.pollWrite ?? false) else { return }
        
        let stoppedPolls = pollModel.polls.filter { $0.state == .stopped }
        pollsOptionAppearance.containsItems.wrappedValue = !currentPolls.isEmpty || !stoppedPolls.isEmpty

        for newPoll in newPolls {
            let notification = HMSRoomKitNotification(id: newPoll.pollID, type: .poll(type: newPoll.category), actor: newPoll.createdBy?.name ?? "", isDismissible: true, title: "\(newPoll.createdBy?.name ?? "") started a new \(newPoll.category == .poll ? "poll": "quiz")")
            roomKitModel.addNotification(notification)
            
            pollsOptionAppearance.badgeState.wrappedValue = .badged
        }
        
        if currentPolls.isEmpty {
            pollsOptionAppearance.badgeState.wrappedValue = .none
        }
    }
    
    func setupPollCreateModel() {
        let center = roomModel.interactivityCenter
        if let role = roomModel.localPeerModel?.role {
            pollCreateModel = PollCreateModel(interactivityCenter: center, limitViewResultsToRoles: [role], currentRole: role)
            pollCreateModel?.onPollStart = { [weak pollCreateModel] in
                let pollId = pollCreateModel?.createdPoll?.pollID ?? ""
                Task {
                    try await roomModel.send(hlsMetadata: [HMSHLSTimedMetadata(payload: "poll:\(pollId)", duration: HMSPrebuiltConferenceView.hlsCueDuration)])
                }
            }
        }
    }
}

struct HMSPrebuiltConferenceView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPrebuiltConferenceView()
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environmentObject(HMSRoomInfoModel())
            .environmentObject(HMSUITheme())
#endif
    }
}
