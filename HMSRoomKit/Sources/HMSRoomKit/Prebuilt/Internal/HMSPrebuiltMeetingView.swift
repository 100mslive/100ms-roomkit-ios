//
//  HMSRoomView.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 29/05/2023.
//

import SwiftUI
import HMSSDK

struct HMSPrebuiltMeetingView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var roomInfoModel: HMSRoomInfoModel
    
    var onDismiss: (() -> Void)?
    init(onDismiss: (() -> Void)?) {
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        
        Group {
            switch roomModel.roomState {
            case .meeting:
                ZStack {
                    HMSConferenceScreen {
                        switch roomInfoModel.conferencingType {
                        case .default:
                            return .default { screen in
                                if let defaultScreen = roomInfoModel.defaultConferencingScreen {
                                    
                                    if let chat = defaultScreen.elements?.chat {
                                        screen.chat = .init(initialState: chat.initial_state == .CHAT_STATE_OPEN ? .open : .close, isOverlay: chat.is_overlay ?? false, allowsPinningMessages: chat.allow_pinning_messages ?? false)
                                    }
                                    
                                    if let tileLayout = defaultScreen.elements?.video_tile_layout?.grid {
                                        screen.tileLayout = .init(grid: .init(isLocalTileInsetEnabled: tileLayout.enable_local_tile_inset ?? false, prominentRoles: tileLayout.prominent_roles ?? [], canSpotlightParticipant: tileLayout.enable_spotlighting_peer ?? false))
                                    }
                                    
                                    if let on_stage_exp = defaultScreen.elements?.on_stage_exp {
                                        screen.onStageExperience = .init(onStageRoleName: on_stage_exp.on_stage_role, rolesWhoCanComeOnStage: on_stage_exp.off_stage_roles, bringToStageLabel: on_stage_exp.bring_to_stage_label, removeFromStageLabel: on_stage_exp.remove_from_stage_label)
                                    }
                                }
                            }
                        case .liveStreaming:
                            return .liveStreaming { screen in
                                if let defaultScreen = roomInfoModel.liveStreamingConferencingScreen {
                                    
                                    if let chat = defaultScreen.elements?.chat {
                                        screen.chat = .init(initialState: chat.initial_state == .CHAT_STATE_OPEN ? .open : .close, isOverlay: chat.is_overlay ?? false, allowsPinningMessages: chat.allow_pinning_messages ?? false)
                                    }
                                    
                                    if let tileLayout = defaultScreen.elements?.video_tile_layout?.grid {
                                        screen.tileLayout = .init(grid: .init(isLocalTileInsetEnabled: tileLayout.enable_local_tile_inset ?? false, prominentRoles: tileLayout.prominent_roles ?? [], canSpotlightParticipant: tileLayout.enable_spotlighting_peer ?? false))
                                    }
                                    
                                    if let on_stage_exp = defaultScreen.elements?.on_stage_exp {
                                        screen.onStageExperience = .init(onStageRoleName: on_stage_exp.on_stage_role, rolesWhoCanComeOnStage: on_stage_exp.off_stage_roles, bringToStageLabel: on_stage_exp.bring_to_stage_label, removeFromStageLabel: on_stage_exp.remove_from_stage_label)
                                    }
                                }
                            }
                        }
                    }
                    .onAppear() {
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                    if !roomModel.roleChangeRequests.isEmpty {
                        HMSPreviewRoleScreen()
                    }
                }
            case .none:
                
                switch roomInfoModel.previewType {
                case .default, .none:
                    HMSPreviewScreen { screen in
                        if let defaultScreen = roomInfoModel.defaultPreviewScreen {
                            screen = .init(title: defaultScreen.elements?.preview_header?.title ?? "", subTitle: defaultScreen.elements?.preview_header?.sub_title ?? "", joinButtonType: defaultScreen.elements?.join_form?.join_btn_type == .join ? .join : .goLive, joinButtonLabel: defaultScreen.elements?.join_form?.join_btn_label ?? "", goLiveButtonLabel: defaultScreen.elements?.join_form?.go_live_btn_label ?? "")
                        }
                    }
                    .onAppear() {
                        UIApplication.shared.isIdleTimerDisabled = true
                        Task {
                            try await roomModel.preview()
                        }
                    }
                }
                
            case .leave:
                HMSEndCallScreen(onDismiss: onDismiss)
                    .onAppear() {
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
            @unknown default:
                fatalError()
            }
        }
        .onChange(of: roomModel.userRole) { role in
            if let role = role {
                roomInfoModel.update(role: role.name)
            }
        }
    }
}

struct HMSPrebuiltMeetingView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPrebuiltMeetingView()
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
