//
//  HMSParticipantsListView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 07/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

#if !Preview
import HMSSDK
#endif
import Combine
import HMSRoomModels

class PeerSectionViewModel: ObservableObject, Identifiable {
    internal init(name: String) {
        self.name = name
        self.peers = []
        self.expanded = true
    }
    
    typealias ID = String
    var id: String {
        name
    }
    
    @Published var expanded: Bool {
        didSet {
            HMSParticipantListViewModel.expandStateCache[name] = expanded
        }
    }
    var name: String
    var count: Int {
        peers.count
    }
    @Published var peers: [PeerViewModel]
}

class PeerViewModel: ObservableObject, Identifiable {
    internal init(peerModel: HMSPeerModel) {
        self.peerModel = peerModel
    }
    
    typealias ID = String
    var id: String {
        peerModel.id + (raisedHandEntry ? "raised" : "")
    }
    
    var raisedHandEntry = false
    var peerModel: HMSPeerModel
    var isLast = false
    var justJoined = false
}

class HMSParticipantListViewModel {
    static let commonSortOrderMap = [handRaisedSectionName.lowercased(), "host", "guest", "teacher", "student", "viewer"].enumerated().reduce(into: [String: Int]()) {
        $0[$1.1] = $1.0
    }
    
    static var expandStateCache = [String: Bool]()
    static let handRaisedSectionName = "Hand Raised"
    
    static func makeDynamicSectionedPeers(from peers: [HMSPeerModel], searchQuery: String) -> [PeerSectionViewModel] {

        let handRaisedSection = PeerSectionViewModel(name: handRaisedSectionName)
        let roleSectionMap = [handRaisedSectionName: handRaisedSection]
        handRaisedSection.expanded = expandStateCache[handRaisedSectionName] ?? true
        
        var peerMap = [handRaisedSectionName : [PeerViewModel]()]
        
        peers.forEach { peer in
            if !searchQuery.isEmpty, !peer.name.lowercased().contains(searchQuery.lowercased()) {
                return
            }
                
            if peer.status == .handRaised {
                let model = PeerViewModel(peerModel: peer)
                model.raisedHandEntry = true
                peerMap[handRaisedSectionName]?.append(model)
            }
        }
        
        roleSectionMap.forEach { (key: String, value: PeerSectionViewModel) in
            value.peers = peerMap[value.name] ?? []
            value.peers.last?.isLast = true
        }
        
        return Array(roleSectionMap.values).filter { $0.count > 0 }
    }
    
    static func makeSectionedPeers(from peers: [HMSPeerModel], roles: [RoleType], searchQuery: String) -> [PeerSectionViewModel] {
        
        let roleSectionMap = roles.reduce(into: [String: PeerSectionViewModel]()) {
            let newSection = PeerSectionViewModel(name: $1.name)
            $0[$1.name] = newSection
            newSection.expanded = expandStateCache[$1.name] ?? true
        }
        
        var peerMap = roles.reduce(into: [String: [PeerViewModel]]()) {
            $0[$1.name] = [PeerViewModel]()
        }
        
        peers.forEach { peer in
            if !searchQuery.isEmpty, !peer.name.lowercased().contains(searchQuery.lowercased()) {
                return
            }
            
            guard let roleName = peer.role?.name else { return }
            peerMap[roleName]?.append(PeerViewModel(peerModel: peer))
        }
        
        roleSectionMap.forEach { (key: String, value: PeerSectionViewModel) in
            value.peers = peerMap[value.name] ?? []
            value.peers.last?.isLast = true
        }
        
        return Array(roleSectionMap.values).filter { $0.count > 0 }
            .sorted {
                let firstOrder = commonSortOrderMap[$0.name.lowercased()] ?? Int.max
                let secondOrder = commonSortOrderMap[$1.name.lowercased()] ?? Int.max
                if firstOrder != secondOrder {
                    return firstOrder < secondOrder
                } else {
                    return $0.name < $1.name
                }
            }
    }
}

struct HMSParticipantListView: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @State var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                HMSSearchField(searchText: $searchText, placeholder: "Search for participants")
            }
            ScrollView {
                LazyVStack(spacing: 0) {
                    let dynamicSections = HMSParticipantListViewModel.makeDynamicSectionedPeers(from: roomModel.remotePeersWithRaisedHand, searchQuery: searchText)
                    ForEach(dynamicSections) { peerSectionModel in
                        ParticipantSectionView(model: peerSectionModel)
                        Spacer().frame(height: 16)
                    }
                    
                    let sections = HMSParticipantListViewModel.makeSectionedPeers(from: roomModel.peerModels, roles: roomModel.roles, searchQuery: searchText)
                    ForEach(sections) { peerSectionModel in
                        ParticipantSectionView(model: peerSectionModel)
                        Spacer().frame(height: 16)
                    }
                }
            }
            
        }
        .padding(.horizontal, 16)
        .background(.surfaceDim, cornerRadius: 0, ignoringEdges: .all)
    }
}

struct ParticipantSectionView: View {
    @ObservedObject var model: PeerSectionViewModel
    
    var body: some View {
        ParticipantItemHeader(name: "\(model.name.capitalized) (\(model.count))", expanded: $model.expanded)
        if model.expanded {
            ForEach(model.peers) { peer in
                ParticipantItem(model: peer, wrappedModel: peer.peerModel)
            }
        }
    }
}

struct ParticipantItemHeader: View {
    @EnvironmentObject var currentTheme: HMSUITheme
    var name: String
    @Binding var expanded: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text(name).font(.subtitle2Semibold14).foreground(.onSurfaceMedium).padding(.vertical, 14)
                Spacer()                
                Image(assetName: "chevron-up")
                    .foreground(.onSurfaceHigh)
                    .rotation3DEffect(.degrees(180), axis: (x: !expanded ? 1 : 0, y: 0, z: 0))
                    .padding(.horizontal, 5)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(currentTheme.colorTheme.borderBright, lineWidth: 1).padding(EdgeInsets(top: 0, leading: 0, bottom: expanded ? -8 : 0, trailing: 0))
            )
            HMSDivider(color: currentTheme.colorTheme.borderDefault).opacity(expanded ? 1 : 0)
        }.clipped().onTapGesture {
            expanded = !expanded
        }
    }
}


struct ParticipantItem: View {
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomModel: HMSRoomModel
    @ObservedObject var model: PeerViewModel
    @ObservedObject var wrappedModel: HMSPeerModel
     
    @State var isPresented = false
    @State var menuAction: HMSPeerOptionsViewContext.Action = .none
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 0) {
                Text(model.peerModel.name).font(.subtitle2Semibold14).lineLimit(1)
                    .truncationMode(.tail).foreground(.onSurfaceHigh)
            }
            Spacer()
           
            HStack(spacing: 16) {
                if wrappedModel.status == .handRaised {
                    Circle()
                        .foreground(.secondaryDim)
                        .overlay {
                            Image(assetName: "hand-raise-icon").renderingMode(.original).resizable().aspectRatio(contentMode: .fit).frame(width: 18, height: 18)}.frame(width: 24, height: 24)
                }
                if let model = wrappedModel.regularAudioTrackModel {
                    HMSAudioTrackView(trackModel: model, style: .list)
                        .environmentObject(self.model.peerModel)
                }
                HMSWifiSignalView(level: wrappedModel.displayQuality, style: .list)
                
                HMSPeerOptionsButtonView(peerModel: model.peerModel) {
                    Image(assetName: "vertical-ellipsis")
                        .foreground(.onSurfaceHigh)
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                }
            }
        }
        .padding(EdgeInsets(top: 17, leading: 16, bottom: 17, trailing: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(currentTheme.colorTheme.borderBright, lineWidth: 1).padding(EdgeInsets(top: -8, leading: 0, bottom: model.isLast ? 0 : -8, trailing: 0))
        ).clipped()
    }
}

struct HMSSearchField: View {
    enum Style {
    case light
    case dark
    }
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @Binding var searchText: String
    var placeholder: String
    var style: Style = .light
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foreground(.onSurfaceMedium)
            TextField("", text: $searchText, prompt: Text(placeholder))
                .foreground(.onSurfaceMedium)
                .font(.body2Regular14)
        }
        .padding(.horizontal, 16)
        .frame(height: 40)
        .background(style == .light ? .surfaceDefault : .surfaceDim, cornerRadius: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style == .light ? currentTheme.colorTheme.borderDefault : currentTheme.colorTheme.borderBright, lineWidth: 1)
        );
    }
}

struct HMSParticipantListView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSParticipantListView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(5))
            .environmentObject(HMSRoomInfoModel())
#endif
    }
}

extension HMSPeerModel {
    func popoverContext(roomModel: HMSRoomModel, roomInfoModel: HMSRoomInfoModel, isPresented: Binding<Bool>, menuAction: Binding<HMSPeerOptionsViewContext.Action>) -> HMSPeerOptionsViewContext? {
        let audioTrackModel = regularAudioTrackModel
        let regularVideoTrackModel = regularVideoTrackModel
        let isLocal = isLocal
        guard let permissions = roomModel.localPeerModel?.role?.permissions else {
            return nil
        }
        
        let currentRole = role?.name ?? ""
        let isOnStage = roomInfoModel.onStageRole == currentRole
        let isOffStage = roomInfoModel.offStageRoles.contains(currentRole)
        
        var actions = [HMSPeerOptionsViewContext.Action]()
        
        if !isLocal {
            if isOffStage && roomInfoModel.isBroadcaster {
                actions.append(.bringOnStage(roomInfoModel.bringToStageLabel))
            } else if roomInfoModel.isBroadcaster && isOnStage {
                actions.append(.removeFromeStage(roomInfoModel.removeFromStageLabel))
            }
        }
        
        let hasAudioTrack = audioTrackModel != nil
        let hasVideoTrack = regularVideoTrackModel != nil
        
        if hasVideoTrack || hasAudioTrack {
            actions.append(.pin(self))
            actions.append(.spotlight(self))
        }
        
        if isLocal {
            actions.append(.changeName)
            actions.append(.minimizeTile)
        } else {
            let canMute = permissions.mute == true
            if canMute {
                if hasAudioTrack {
                    let isAudioMute = audioTrackModel?.isMute == true
                    actions.append(.audioMuteToggle(isAudioMute))
                }
                
                if hasVideoTrack {
                    let isVideoMute = regularVideoTrackModel?.isMute == true
                    actions.append(.videoMuteToggle(isVideoMute))
                }
            }
            
            if hasAudioTrack {
                actions.append(.volume)
            }
            
            let canRemoveOthers = permissions.removeOthers == true
            if canRemoveOthers {
                actions.append(.removeParticipant)
            }
        }
        
        return HMSPeerOptionsViewContext(isPresented: isPresented, action: menuAction, name: name + (isLocal ? " (You)" : ""), role: role?.name.capitalized ?? "", actions: actions)
    }
}
