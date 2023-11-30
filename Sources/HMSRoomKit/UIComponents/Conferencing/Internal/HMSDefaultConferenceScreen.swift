//
//  HMSRoomMainView.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 29/05/2023.
//

import SwiftUI
import AVKit
import HMSSDK
import HMSRoomModels

public struct HMSDefaultConferenceScreen: View {
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @Environment(\.controlsState) var controlsState
    @State private var tabPageBarState = EnvironmentValues.HMSTabPageBarState.hidden
    @State private var menuContext = EnvironmentValues.MenuContext.none
    @State private var keyboardState = EnvironmentValues.HMSKeyboardState.hidden
    @State private var chatBadgeState = EnvironmentValues.HMSChatBadgeState.none
    
    @State var isChatPresented = false
    
    @EnvironmentObject var roomKitModel: HMSRoomNotificationModel
    
    let isHLSViewer: Bool
    
    @Environment(\.userStreamingState) var userStreamingState
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    public var body: some View {
        
        let isChatOverlay = conferenceComponentParam.chat?.isOverlay ?? false
        let chatInitialState = conferenceComponentParam.chat?.initialState ?? .close
        
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                
                if !isHLSViewer {
                    if userStreamingState.wrappedValue == .none {
                        HMSTopControlStrip()
                            .padding([.bottom,.horizontal], 16)
                            .transition(.move(edge: .top))
                            .frame(height: controlsState.wrappedValue == .hidden ? 0 : nil)
                            .opacity(controlsState.wrappedValue == .hidden ? 0 : 1)
                    }
                }
                
                if isChatOverlay {
                    HMSMainConferenceView(isChatPresented: $isChatPresented, isHLSViewer: isHLSViewer, isChatOverlay: isChatOverlay)
                }
                else {
                    HMSMainConferenceView(isChatPresented: $isChatPresented, isHLSViewer: isHLSViewer, isChatOverlay: isChatOverlay)
                        .sheet(isPresented: $isChatPresented) {
                            if #available(iOS 16.0, *) {
                                HMSChatParticipantToggleView().presentationDetents([.large])
                            } else {
                                HMSChatParticipantToggleView()
                            }
                        }
                }
                
                if !isHLSViewer {
                    if userStreamingState.wrappedValue == .none {
                        HMSBottomControlStrip(isChatPresented: $isChatPresented)
                            .padding(tabPageBarState == .hidden ? [.horizontal, .top] : [.horizontal], 16)
                            .transition(.move(edge: .bottom))
                            .frame(height: controlsState.wrappedValue == .hidden ? 0 : nil)
                            .opacity(controlsState.wrappedValue == .hidden ? 0 : 1)
                            .zIndex(-1)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(userStreamingState.wrappedValue == .starting ? [.all] : [])
        .onAppear() {
            isChatPresented = chatInitialState == .open
        }
        //            .padding(.vertical, 5)
        .overlay(alignment: .top) {
            if !roomModel.isUserJoined {
                GeometryReader { geo in
                    VStack {
                        Rectangle()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .foreground(.backgroundDim)
                            .opacity(0.64)
                    }
                }
                .onTapGesture {
                    // block taps
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        // chat overlay
        .overlay(alignment: .bottom) {
            HMSChatOverlay(isChatPresented: $isChatPresented, isHLSViewer: isHLSViewer, isChatOverlay: isChatOverlay)
        }
        .overlay {
            if userStreamingState.wrappedValue == .starting {
                LinearGradient(
                    gradient: Gradient(colors: [currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(1.0), currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // block tap gesture from propagating
                }
            }
        }
        .overlay(alignment: .center) {
            if !isHLSViewer && userStreamingState.wrappedValue == .starting {
                HStack {
                    Spacer(minLength: 0)
                    VStack(spacing: 29) {
                        Spacer(minLength: 0)
                        HMSLoadingScreen()
                        Text("Starting live stream...")
                            .font(.body1Regular16)
                            .foreground(.onSurfaceHigh)
                        Spacer(minLength: 0)
                    }
                    Spacer(minLength: 0)
                }
                .background(roomModel.isCameraMute ? .backgroundDim : nil, cornerRadius: 0, ignoringEdges: .all)
            }
        }
        .onTapGesture {
            checkAndHideControls()
        }
        .onAppear() {
            roomModel.beginObserving(keys: [HMSRoomModel.spotlightKey, HMSRoomModel.pinnedMessageKey, HMSRoomModel.chatPeerBlacklistKey, HMSRoomModel.chatMessageBlacklistKey])
        }
        .animation(.default, value: userStreamingState.wrappedValue)
#if !Preview
        .onChange(of: roomModel.remotePeersWithRaisedHand) { currentlyRaisedHandsPeers in
            let previouslyRaisedHandsPeerIds = roomKitModel.notifications.filter{$0.type == .handRaised}.map{$0.id}
            
            let newPeersWhoHaveRaisedHands = currentlyRaisedHandsPeers.filter{!previouslyRaisedHandsPeerIds.contains($0.id)}
            let peerIdsWhoHaveLoweredHands = previouslyRaisedHandsPeerIds.filter{!currentlyRaisedHandsPeers.map{$0.id}.contains($0)}
            
            // Remove notification for peers who have lowered their hands
            roomKitModel.removeNotification(for: peerIdsWhoHaveLoweredHands)
            
            let onStageExperience = conferenceComponentParam.onStageExperience
            guard let rolesWhoCanComeOnStage = onStageExperience?.rolesWhoCanComeOnStage else {
                return
            }
            
            // add notification for each new peer
            for newPeer in newPeersWhoHaveRaisedHands {
                guard let role = newPeer.role?.name,
                      rolesWhoCanComeOnStage.contains(role)
                    else { continue }
                let notification = HMSRoomKitNotification(id: newPeer.id, type: .handRaised, actor: newPeer.name, isDismissible: true, title: "\(newPeer.name) raised hand")
                roomKitModel.addNotification(notification)
            }
        }
        .onChange(of: roomModel.peersSharingScreen.filter{$0.isLocal}) { peers in
            if let localPeer = peers.first {
                let notification = HMSRoomKitNotification(id: localPeer.id, type: .screenShare, actor: localPeer.name, isDismissible: false, title: "You are sharing your screen")
                roomKitModel.addNotification(notification)
            }
            else {
                roomKitModel.removeNotifications(of: .screenShare)
            }
        }
        .onChange(of: roomModel.isReconnecting) { isReconnecting in
            if isReconnecting {
                let notification = HMSRoomKitNotification(id: "isReconnecting", type: .info(icon: "loading-record"), actor: "isReconnecting", isDismissible: false, title: "You have lost your network connection. Trying to reconnect.")
                roomKitModel.addNotification(notification)
            }
            else {
                roomKitModel.removeNotification(for: ["isReconnecting"])
            }
        }
        .onChange(of: roomModel.recordingState) { recordingState in
            if recordingState == .failed {
                let notification = HMSRoomKitNotification(id: "RecordingFailed", type: .error(icon: "recording-failed-icon", retry: true, isTerminal: false), actor: "RecordingFailed", isDismissible: true, title: "Recording failed to start")
                roomKitModel.addNotification(notification)
            }
            else {
                roomKitModel.removeNotification(for: ["RecordingFailed"])
            }
        }
        .onChange(of: roomModel.errors.compactMap{$0 as? HMSError}) { hmsErrors in
            
            let previousErrorIds = roomKitModel.notifications.filter {
                if case .error(icon: _, retry: _, isTerminal: _) = $0.type {
                    return true
                }
                else {
                    return false
                }
            }.map{$0.id}
            
            let newErrors = hmsErrors.filter{!previousErrorIds.contains("\($0.hashValue)")}
            
            for error in newErrors {
                let notification = HMSRoomKitNotification(id: String(error.hashValue), type: .error(icon: "warning-icon", retry: error.canRetry, isTerminal: error.isTerminal), actor: String(error.hashValue), isDismissible: false, title: "An error occurred \(error.localizedDescription)")
                roomKitModel.addNotification(notification)
            }
        }
        .onChange(of: roomModel.serviceMessages) { message in
            let existingIDs = Set(roomKitModel.notifications.filter { $0.type == .declineRoleChange }.map { $0.id } )
            roomModel.serviceMessages.filter { !existingIDs.contains($0.messageID) && $0.type == HMSRoomModel.roleChangeDeclinedNotificationType }
                .forEach {
                    let notification = HMSRoomKitNotification(id: $0.messageID, type: .declineRoleChange, actor: $0.sender?.name ?? "Someone", isDismissible: true, title: "\($0.sender?.name ?? "Someone") declined the request to join the stage")
                    roomKitModel.addNotification(notification)
                }
        }
        .onChange(of: roomModel.messages) { message in
            if !isChatPresented {
                chatBadgeState = .badged
            }
        }
        .onChange(of: isChatPresented) { isChatPresented in
            chatBadgeState = .none
        }
#endif
        .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
        .environment(\.menuContext, $menuContext)
        .environment(\.tabPageBarState, $tabPageBarState)
        .environment(\.keyboardState, $keyboardState)
        .environment(\.chatBadgeState, $chatBadgeState)
    }
    
    func checkAndHideControls() {
        
        guard keyboardState == .hidden else {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            return
        }
        
        if menuContext == .none {
            withAnimation {
                controlsState.wrappedValue = controlsState.wrappedValue == .hidden ? .visible : .hidden
            }
        }
        else {
            menuContext = .none
        }
    }
}

struct HMSDefaultConferencingScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        let roomKitModel: HMSRoomNotificationModel = {
            let model = HMSRoomNotificationModel()
            model.notifications.append(.init(id: "id1", type: .handRaised, actor: "Pawan", isDismissible: true, title: "Peer1 raised hands Peer1 raised hands"))
            model.notifications.append(.init(id: "id2", type: .handRaised, actor: "Dmitry", isDismissible: true, title: "Peer2", isDismissed: true))
            model.notifications.append(.init(id: "id3", type: .handRaised, actor: "Praveen", isDismissible: true, title: "Peer3 raised hands"))
            model.notifications.append(.init(id: "id4", type: .handRaised, actor: "Bajaj", isDismissible: true, title: "Peer4 raised hands"))
            model.notifications.append(.init(id: "id5", type: .declineRoleChange, actor: "Bajaj", isDismissible: true, title: "Peer5 declined request"))
            model.notifications.append(.init(id: "id6", type: .declineRoleChange, actor: "Bajaj", isDismissible: true, title: "Peer6 declined request2"))
            model.notifications.append(.init(id: "id7", type: .declineRoleChange, actor: "Bajaj", isDismissible: true, title: "Peer7 declined request3"))
            return model
        }()
        
        HMSDefaultConferenceScreen(isHLSViewer: true)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2, [.prominent, .prominent]))
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomInfoModel())
            .environmentObject(roomKitModel)
            .environment(\.conferenceParams, .init(chat: .init(initialState: .open, isOverlay: true, allowsPinningMessages: true, chatScopes: [.private, .public]), tileLayout: .init(grid: .init(isLocalTileInsetEnabled: true, prominentRoles: ["stage"], canSpotlightParticipant: true))))
#endif
    }
}
