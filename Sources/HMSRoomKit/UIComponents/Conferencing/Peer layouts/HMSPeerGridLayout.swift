//
//  HMSPaginatedView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 19/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSPeerGridLayout: View {
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    var peersInOnePage = 6
    var prominentPeers: [HMSPeerModel] = []
    
    @Environment(\.controlsState) private var controlsState
    @Environment(\.tabPageBarState) var tabPageBarState
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @State private var selectedPageIndex = 0
    @State var isOnFirstPage = true
    
    @State var logs = [String]()
    
    var body: some View {
        
        let isInsetMode = conferenceComponentParam.tileLayout?.grid.isLocalTileInsetEnabled ?? false
        let visiblePeers = roomModel.visiblePeersInLayout(isUsingInset: isInsetMode)
        
        let screenSharingPeers = roomModel.peersSharingScreen.filter{!$0.isLocal}
        let numberOfPeers = visiblePeers.count
        let highlightedPeers: [HMSPeerModel] = (roomModel.highlightedPeers + prominentPeers).combinedWithoutDuplicates
        
        if screenSharingPeers.count > 0 {
            HMSScreenProminenceLayout()
        }
        else if highlightedPeers.count > 0 {
            HMSPeerProminenceLayout(prominentPeers: highlightedPeers)
        }
        else {
            
            if numberOfPeers < 4 {
                HMSPeerVerticalListLayout()
            }
            else {
                VStack(spacing: 0) {
                    
                    TabView(selection: $selectedPageIndex) {
                        let chunks = visiblePeers.chunks(ofCount: peersInOnePage)
                        
                        ForEach(chunks.indices, id:\.self) { index in
                            let chunk = chunks[index]
                            TallVGrid(items: Array(chunk), idKeyPath: \.self, numOfColumns: 2, vhSpacing: 8, isTrailing: numberOfPeers > peersInOnePage, maxItemInOnePage: 6, content: { peer in
                                HMSPeerTile(peerModel: peer)
                                    .background(.backgroundDefault, cornerRadius: 0)
                            })
                            .onAppear() {
                                if index != 0 {
                                    isOnFirstPage = false
                                }
                            }
                            .onDisappear() {
                                if index != 0 && selectedPageIndex == 0 {
                                    isOnFirstPage = true
                                }
                            }
                            .tag(index)
                        }
                        .padding(.bottom, 35)
                    }
                    .tabViewStyle(.page)
                    .onAppear() {
                        tabPageBarState.wrappedValue = .visible
                    }
                    .onDisappear() {
                        tabPageBarState.wrappedValue = .hidden
                    }
                    .onChange(of: roomModel.speakers) { _ in
                        logs.append("\(Date()) New speakers: \(roomModel.speakers.map{$0.name})")
                        guard isOnFirstPage && numberOfPeers > peersInOnePage else {
                            logs.append("\(Date()) NA: Not on first page or pagination disabled")
                            return
                        }
                        performActiveSpeakerSort(maxSpeakerCount: peersInOnePage, excludeLocalPeer: isInsetMode)
                    }
                }
            }
        }
    }
    
    @MainActor func performActiveSpeakerSort(maxSpeakerCount: Int, excludeLocalPeer: Bool = true) {
        
        if excludeLocalPeer {
            if let localPeer = roomModel.peerModels.prefix(maxSpeakerCount).first(where: {$0.isLocal}) {
                logs.append("Moving local peer to last index")
                roomModel.peerModels.move(localPeer, to: roomModel.peerModels.count - 1)
            }
        }
        
        let peers = excludeLocalPeer ? roomModel.remotePeerModelsExcludingViewers : roomModel.peerModels
        let peersOnFirstPage = peers.prefix(maxSpeakerCount)
        let speakers = excludeLocalPeer ? roomModel.speakers.filter{!$0.isLocal} : roomModel.speakers
        
        let speakersNotInFirstScreen = speakers.filter{!peersOnFirstPage.contains($0)}
        
        logs.append("SpeakersNotInFirstScreen: \(speakersNotInFirstScreen.map{$0.name})")
        
        if speakersNotInFirstScreen.count > 0 {
            logs.append("\(Date()) Perform Active Speaker sort")
            
            var sortedPeersByFirstSpoken = peersOnFirstPage.sorted{$0.lastSpokenTimestamp < $1.lastSpokenTimestamp}
            
            logs.append("SortedPeersByFirstSpoken: \(sortedPeersByFirstSpoken.map{$0.name})")
            
            speakersNotInFirstScreen.forEach { speaker in
                
                logs.append("Bringing speaker \(speaker.name) to first screen")
                
                if let firstSpokenPeer = sortedPeersByFirstSpoken.first, let firstSpokenPeerIndex = roomModel.peerModels.firstIndex(of: firstSpokenPeer) {
                    
                    logs.append("Moving new speaker \(speaker.name) to index \(firstSpokenPeerIndex)")
                    roomModel.peerModels.move(speaker, to: firstSpokenPeerIndex)
                    
                    if peersInOnePage < peers.count {
                        logs.append("Moving firstSpokenPeer \(firstSpokenPeer.name) to index \(peersInOnePage)")
                        roomModel.peerModels.move(firstSpokenPeer, to: peersInOnePage)
                    }
                    
                    sortedPeersByFirstSpoken = Array(sortedPeersByFirstSpoken.dropFirst())
                }
                else {
                    // do nothing
                }
            }
        }
    }
}

struct HMSPeerGridLayout_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerGridLayout()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(13))
            .environmentObject(HMSRoomInfoModel())
#endif
    }
}
