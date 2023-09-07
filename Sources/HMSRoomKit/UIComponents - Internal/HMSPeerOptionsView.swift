//
//  HMSPeerOptionsView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 05/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

struct HMSPeerOptionsViewContext {
    enum Action: Equatable, Hashable {
        case videoMuteToggle(Bool)
        case audioMuteToggle(Bool)
        case pin(HMSPeerModel)
        case spotlight(HMSPeerModel)
        case changeName
        case volume
        case removeParticipant
        case minimizeTile
        case bringOnStage(String)
        case removeFromeStage(String)
        case lowerHand
        case none
    }
    
    @Binding var isPresented: Bool
    @Binding var action: Action
    var volume: Binding<Double>?
    var name: String
    var role: String
    
    var actions: [HMSPeerOptionsViewContext.Action]
}

struct HMSPeerOptionsButtonView<Content: View>: View {
    @Environment(\.menuContext) var menuContext
    
    @AppStorage("isInsetMinimized") var isInsetMinimized: Bool = false
    
    @State private var isPresented = false
    @State private var menuAction: HMSPeerOptionsViewContext.Action = .none
    let label: () -> Content
    let dismiss:(() -> Void)?
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomInfoModel: HMSRoomInfoModel
    
    @ObservedObject var peerModel: HMSPeerModel
    
    internal init(peerModel: HMSPeerModel, dismiss: (() -> Void)? = nil, @ViewBuilder label: @escaping (() -> Content)) {
        self.peerModel = peerModel
        self.label = label
        self.dismiss = dismiss
    }
    
    var body: some View {
        if let context = peerModel.popoverContext(roomModel: roomModel, roomInfoModel: roomInfoModel, isPresented: $isPresented, menuAction: $menuAction) {
            label()
                .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .local).onEnded({ _ in
                    isPresented.toggle()
                }))
                .opacity(context.actions.isEmpty ? 0 : 1)
                .sheet(isPresented: $isPresented, onDismiss: {
                    dismiss?()
                }) {
                    HMSSheet {
                        HMSPeerOptionsView(context: context)
                            .environmentObject(roomModel)
                            .environmentObject(peerModel)
                    }
                    .edgesIgnoringSafeArea(.all)
                    .environmentObject(currentTheme)
                }
                .onChange(of: menuAction) { value in
                    switch value {
                    case .videoMuteToggle:
                        break
                    case .audioMuteToggle:
                        break
                    case .removeParticipant:
                        break
                    case .minimizeTile:
                        break
                    case .bringOnStage:
                        break
                    case .removeFromeStage:
                        break
                    case .lowerHand:
                        Task {
                            try await roomModel.lowerHand(of: peerModel)
                        }
                        break
                    case .pin(let peer):
                        if roomModel.pinnedPeers.contains(peer) {
                            roomModel.pinnedPeers.removeAll{$0 == peer}
                        }
                        else {
                            roomModel.pinnedPeers.append(peer)
                        }
                    case .spotlight(let peer):
                        roomModel.spotlightedPeer = roomModel.spotlightedPeer == peer ? nil : peerModel
                    default:
                        break
                    }
                }
        }
    }
}

struct HMSOptionsHeaderView: View {
    
    var title: String
    var subtitle: String?
    var showsBackButton: Bool = false
    var onClose: (() -> Void)?
    var onBack: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                if showsBackButton {
                    Image(assetName: "back")
                        .foreground(.onSurfaceHigh)
                        .onTapGesture {
                            onBack?()
                        }
                    Spacer()
                        .frame(width:8)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subtitle1).foreground(.onSurfaceHigh)
                    if let subtitle = subtitle {
                        Text(subtitle).font(.captionRegular12).foreground(.onSurfaceMedium)
                    }
                }
                Spacer()
                Image(assetName: "close")
                    .foreground(.onSurfaceHigh)
                    .onTapGesture {
                        onClose?()
                    }
            }
            .padding(.horizontal, showsBackButton ? 16 : 24)
            .padding(.vertical, 16)
            
            Divider()
                .background(.borderDefault, cornerRadius: 0)
                .padding(.bottom, 16)
        }
    }
}

struct HMSPeerOptionsView: View {
    
    @Environment(\.conferenceComponentParam) var conferenceComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var roomInfoModel: HMSRoomInfoModel
    @EnvironmentObject var peerModel: HMSPeerModel
    
    @AppStorage("isInsetMinimized") var isInsetMinimized: Bool = false
    
    var context: HMSPeerOptionsViewContext
    
    @State private var isChangeNameSheetPresented: Bool = false
    
    var body: some View {
        
        let isSpotlightEnabled = conferenceComponentParam.tileLayout?.grid.canSpotlightParticipant ?? false
        
        VStack(alignment: .leading, spacing: 0) {
            HMSOptionsHeaderView(title: peerModel.name + (peerModel.isLocal ? " (You)" : ""), subtitle: context.role, onClose: {
                context.isPresented = false
            })
            VStack(alignment: .leading, spacing: 8) {
                ForEach(context.actions, id: \.self) { action in
                    switch action {
                    case .changeName:
                        HStack {
                            Image(assetName: "pencil")
                            Text("Change Name")
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            isChangeNameSheetPresented = true
                        }
                    case .audioMuteToggle(_):
                        if let regularAudioTrackModel = peerModel.regularAudioTrackModel {
                            HMSPeerAudioMuteOptionView(regularAudioTrackModel: regularAudioTrackModel)
                                .background(.white.opacity(0.0001))
                                .onTapGesture {
                                    Task {
                                        try await peerModel.regularAudioTrackModel?.toggleMute()
                                    }
                                    context.isPresented = false
                                }
                        }
                    case .videoMuteToggle(_):
                        if let regularVideoTrackModel = peerModel.regularVideoTrackModel {
                            HMSPeerVideoMuteOptionView(regularVideoTrackModel: regularVideoTrackModel)
                                .background(.white.opacity(0.0001))
                                .onTapGesture {
                                    Task {
                                        try await peerModel.regularVideoTrackModel?.toggleMute()
                                    }
                                    context.isPresented = false
                                }
                        }
                    case .removeParticipant:
                        HStack {
                            Image(assetName: "peer-remove")
                            Text("Remove Participant").font(.subtitle2Semibold14)
                            Spacer(minLength: 0)
                        }
                        .foreground(.errorDefault)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            roomModel.remove(peer: peerModel)
                            context.isPresented = false
                        }
                    case .minimizeTile:
                        HStack {
                            Image(assetName: "minimize-icon").padding(.horizontal, 3)
                            Text("Minimize Your Video")
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            isInsetMinimized = true
                            context.isPresented = false
                        }
                    case .bringOnStage(let label):
                        HStack {
                            Image(assetName: "stage")
                            Text(label)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            guard !roomInfoModel.onStageRole.isEmpty else { return }
                            Task {
                                try await roomModel.changeRole(of: peerModel, to: roomInfoModel.onStageRole)
                            }
                            context.isPresented = false
                        }
                    case .removeFromeStage(let label):
                        HStack {
                            Image(assetName: "stage")
                            Text(label)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            guard !peerModel.previousRole.isEmpty else {
                                return
                            }
                            Task {
                                try await roomModel.changeRole(of: peerModel, to: peerModel.previousRole, force: true)
                            }
                            context.isPresented = false
                        }
                    case .pin(let peer):
                        HStack {
                            Image(assetName: "pin")
                            Text(roomModel.pinnedPeers.contains(peer) ? "Unpin tile for myself" : "Pin tile for myself")
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            context.action = .none
                            context.action = action
                            context.isPresented = false
                        }
                    case .spotlight(let peer):
                        if isSpotlightEnabled {
                            HStack {
                                Image(assetName: "star")
                                Text(roomModel.spotlightedPeer == peer ? "Remove from spotlight for Everyone" : "Spotlight Tile for Everyone")
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(.white.opacity(0.0001))
                            .onTapGesture {
                                context.action = .none
                                context.action = action
                                context.isPresented = false
                            }
                        }
                    case .volume:
                        if let regularAudioTrackModel = peerModel.regularAudioTrackModel {
                            HMSPeerVolumeOptionView(regularAudioTrackModel: regularAudioTrackModel)
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }.font(.subtitle2Semibold14)
            .foreground(.onSurfaceHigh)
            .sheet(isPresented: $isChangeNameSheetPresented) {
                HMSSheet {
                    HMSChangeNameView()
                }
                .edgesIgnoringSafeArea(.all)
            }
//            .background(.backgroundDim, cornerRadius: 8.0, ignoringEdges: .all)
    }
}


struct HMSPeerOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        let context = HMSPeerOptionsViewContext(isPresented: .constant(true), action: .constant(.none), volume: .constant(1), name:"John", role:"Host", actions: [])
        HMSPeerOptionsView(context: context)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.localPeer)
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
