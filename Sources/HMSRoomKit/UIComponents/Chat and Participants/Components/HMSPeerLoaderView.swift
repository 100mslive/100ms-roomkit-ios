//
//  HMSPeerLoaderView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 12/26/23.
//

import SwiftUI
import HMSRoomModels

struct HMSPeerLoaderView<Content>: View where Content: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    let peerId: String
    @State var peer: HMSPeerModel?
    
    @ViewBuilder let content: (HMSPeerModel) -> Content
    
    init(peerId: String, @ViewBuilder content: @escaping (HMSPeerModel) -> Content) {
        self.peerId = peerId
        self.content = content
    }
    
    var body: some View {
        
        VStack {
            if let peer {
                content(peer)
            }
        }
        .task {
            if let peer = roomModel.remotePeerModels.first(where: {$0.id == peerId}) {
                self.peer = peer
            }
            else if roomModel.isLarge {
                do {
                    peer = try await roomModel.fetchPeer(with: peerId)
                }
                catch {
                    // do nothing
                }
            }
        }
    }
}
