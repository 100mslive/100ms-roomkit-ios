//
//  HMSRoomView.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 29/05/2023.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSPrebuiltMeetingView: View {
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var roomInfoModel: HMSRoomInfoModel
    
    @State var userStreamingState = EnvironmentValues.HMSUserStreamingState.none
    @State private var controlsState = EnvironmentValues.HMSControlsState.visible
    @State private var pollsBadgeState: HMSOptionSheetView.PollsOptionAppearance = .init(.none, containsItems: false)
    
    @StateObject var pollModel = HMSRoomKitPollModel()
    
    var onDismiss: (() -> Void)?
    init(onDismiss: (() -> Void)?) {
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        
        Group {
            switch roomModel.roomState {
            case .inMeeting:
                HMSPrebuiltConferenceView()
                    .onDisappear() {
                        pollModel.polls.removeAll()
                        pollModel.currentPolls.removeAll()
                    }
            case .notJoined:
                switch roomInfoModel.previewType {
                case .none:
                    HMSLoadingScreen().onAppear() {
                        UIApplication.shared.isIdleTimerDisabled = true
                        Task {
                            try await roomModel.joinSession()
                        }
                    }
                case .default:
                    HMSPreviewScreen { screen in
                        if let defaultScreen = roomInfoModel.defaultPreviewScreen {
                            screen = .init(title: defaultScreen.elements?.preview_header?.title ?? "", subTitle: defaultScreen.elements?.preview_header?.sub_title ?? "", joinButtonType: defaultScreen.elements?.join_form.join_btn_type == .join ? .join : .goLive, joinButtonLabel: defaultScreen.elements?.join_form.join_btn_label ?? "", goLiveButtonLabel: defaultScreen.elements?.join_form.go_live_btn_label ?? "", noiseCancellation: .init(startsEnabled: (defaultScreen.elements?.noise_cancellation?.enabled_by_default ?? false) ? true : false), virtualBackgrounds: defaultScreen.elements?.virtual_background?.background_media?.map{ HMSPreviewScreen.DefaultType.VirtualBackground(url: URL(string:$0.url)!, isDefault: $0.default, type: $0.media_type == .image ? .image : .video) } ?? [])
                        }
                    }
                    .onAppear() {
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                }
                
            case .leftMeeting:
                HMSEndCallScreen(onDismiss: onDismiss)
                    .onAppear() {
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
            }
        }
        .onAppear() {
            pollModel.roomModel = roomModel
            pollModel.beginListeningForPolls()
        }
        .environmentObject(pollModel)
        .environment(\.controlsState, $controlsState)
        .environment(\.pollsOptionAppearance, $pollsBadgeState)
        .environment(\.peerTileAppearance, .constant(.init(userStreamingState == .starting ? .compact : .full, isOverlayHidden: (userStreamingState == .starting || controlsState == .hidden))))
        .environment(\.userStreamingState, $userStreamingState)
#if !Preview
        .onChange(of: roomModel.userRole) { role in
            if let role = role {
                roomInfoModel.update(role: role.name)
            }
        }
        #endif
        .onAppear() {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(currentTheme.colorTheme.colorForToken(.onSurfaceHigh))
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(currentTheme.colorTheme.colorForToken(.onSurfaceLow))
        }
    }
}

struct HMSPrebuiltMeetingView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPrebuiltMeetingView(){}
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environmentObject(HMSRoomInfoModel())
            .environmentObject(HMSUITheme())
#endif
    }
}
