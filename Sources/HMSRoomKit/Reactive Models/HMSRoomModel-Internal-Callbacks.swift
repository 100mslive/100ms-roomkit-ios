//
//  HMSUICoordinator.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 29/05/2023.
//

import Combine
import HMSSDK

extension HMSRoomModel {
    private func getAuthToken(roomCode: String) async throws -> String {
        
        if let authToken = authToken {
            return authToken
        }
        else {
            return try await withCheckedThrowingContinuation({ continuation in
                
                sdk.getAuthTokenByRoomCode(roomCode) { authToken, error in
                    guard let authToken = authToken else {
                        continuation.resume(throwing: error!);
                        return
                    }
                    
                    self.authToken = authToken
                    continuation.resume(returning: authToken)
                }
            })
        }
    }
    
    public func getRoomLayout() async throws -> HMSRoomLayout {
        let authToken = try await getAuthToken(roomCode: roomCode)
        
        return try await withCheckedThrowingContinuation({ continuation in
            self.sdk.getRoomLayout(using: authToken) { roomLayout, error in
                guard let roomLayout = roomLayout else {
                    continuation.resume(throwing: error!);
                    return
                }
                
                continuation.resume(returning: roomLayout)
            }
        })
    }
    
    public func preview() async throws {
        let authToken = try await getAuthToken(roomCode: roomCode)
        self.sdk.preview(config: HMSConfig(authToken: authToken, endpoint: UserDefaults.standard.bool(forKey: "useQAEnv") ? "https://qa-init.100ms.live/init" : nil), delegate: self)
    }
    
    public func join(userName: String) async throws {
        let authToken = try await getAuthToken(roomCode: roomCode)
        
        self.sdk.join(config: HMSConfig(userName: userName, authToken: authToken, endpoint: UserDefaults.standard.bool(forKey: "useQAEnv") ? "https://qa-init.100ms.live/init" : nil), delegate: self)
        
        return try await withCheckedThrowingContinuation { continuation in
            
            cancellable = self.$isUserJoined.dropFirst().sink { [weak self] isUserJoined in
                if isUserJoined {
                    continuation.resume()
                    self?.cancellable = nil
                }
                else {
                    if let lastError = self?.lastError {
                        continuation.resume(throwing: lastError)
                        self?.cancellable = nil
                    }
                    else {
                        continuation.resume(throwing: NSError())
                        self?.cancellable = nil
                    }
                }
            }
        }
    }
}

extension HMSRoomModel: HMSUpdateListener {
    
    @MainActor public func on(join room: HMSRoom) {
        assign(room: room)
        roles = sdk.roles
        isUserJoined = true
        // Clean up models received during preview
        peerModels.removeAll()
        
        if localPeerModel == nil {
            if let localPeer = sdk.localPeer {
                insert(peer: localPeer)
            }
        }
        
        updateStreamingState()
    }
    
    @MainActor public func on(room: HMSRoom, update: HMSRoomUpdate) {
        
        if self.room == nil {
            assign(room: room)
        }
        
        switch update {
        case .roomTypeChanged:
            break
        case .metaDataUpdated:
            updateMetadata()
        case .browserRecordingStateUpdated, .hlsRecordingStateUpdated:
            updateRecordingState()
        case .serverRecordingStateUpdated:
            break
        case .hlsStreamingStateUpdated, .rtmpStreamingStateUpdated:
            updateStreamingState()
        case .peerCountUpdated:
            peerCount = room.peerCount
        @unknown default:
            break
        }
    }
    
    @MainActor public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        switch update {
        case .peerJoined:
            insert(peer: peer)
        case .peerLeft:
            remove(peer: peer)
        case .roleUpdated:
            updateRole(for: peer)
        case .nameUpdated:
            updateName(for: peer)
        case .metadataUpdated:
            updateMetadata(for: peer)
        case .networkQualityUpdated:
            updateNetworkQuality(for: peer)
        case .defaultUpdate: break
        @unknown default: break
        }
    }
    
    @MainActor public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        switch update {
        case .trackAdded:
            if peer.isLocal && localPeerModel == nil {
                insert(peer: peer)
            }
            if let peerModel = peerModels.first(where: {$0.peer == peer}) {
                peerModel.insert(track: track)
            }
            
            if peer.isLocal {
                updateLocalMuteState()
            }
        case .trackRemoved:
            if let peerModel = peerModels.first(where: {$0.peer == peer}) {
                peerModel.remove(track: track)
            }
        case .trackMuted:
            if let peerModel = peerModels.first(where: {$0.peer == peer}) {
                peerModel.mute(track: track)
            }
            if peer.isLocal {
                updateLocalMuteState()
            }
        case .trackUnmuted:
            if let peerModel = peerModels.first(where: {$0.peer == peer}) {
                peerModel.unmute(track: track)
            }
            if peer.isLocal {
                updateLocalMuteState()
            }
        case .trackDescriptionChanged: break
        case .trackDegraded:
            if let peerModel = peerModels.first(where: {$0.peer == peer}) {
                peerModel.updateDegradation(for: track, isDegraded: true)
            }
        case .trackRestored:
            if let peerModel = peerModels.first(where: {$0.peer == peer}) {
                peerModel.updateDegradation(for: track, isDegraded: false)
            }
        @unknown default: break
        }
    }
    
    @MainActor public func on(error: Error) {
        errors.append(error)
        if let error = error as? HMSError {
            if error.isTerminal {
                isUserJoined = false
            }
        }
    }
    
    @MainActor public func on(message: HMSMessage) {
        switch message.type {
        case "chat":
            messages.append(message)
        default:
            serviceMessages.append(message)
            break
        }
    }
    
    @MainActor public func on(updated speakers: [HMSSpeaker]) {
        
        let speakingPeers = peerModels.filter{ peerModel in speakers.map{$0.peer.peerID}.contains(peerModel.peer.peerID)}
        
        let allPreviouslySpeakingPeers = peerModels.filter{$0.isSpeaking}
        let peersWhoStoppedSpeaking = allPreviouslySpeakingPeers.filter{!speakingPeers.contains($0)}
        peersWhoStoppedSpeaking.forEach{ $0.isSpeaking = false }
        
        speakingPeers.forEach { peerModel in
            peerModel.lastSpokenTimestamp = Date()
            peerModel.isSpeaking = true
        }
        
        self.speakers = speakingPeers
    }
    
    @MainActor public func onReconnecting() {
        isReconnecting = true
    }
    
    @MainActor public func onReconnected() {
        isReconnecting = false
    }
    
    // optional methods
    @MainActor public func on(roleChangeRequest: HMSRoleChangeRequest) {
        guard roleChangeRequests.isEmpty else { return }
        roleChangeRequests.append(roleChangeRequest)
    }
    
    @MainActor public func on(changeTrackStateRequest: HMSChangeTrackStateRequest) {
        changeTrackStateRequests.append(changeTrackStateRequest)
    }
    
    @MainActor public func on(removedFromRoom notification: HMSRemovedFromRoomNotification) {
        removedFromRoomNotification = notification
        self.roomState = .leave(reason: notification.roomEnded ? .roomEnded : .userKickedOut)
    }
    
    @MainActor public func on(sessionStoreAvailable store: HMSSessionStore) {
        sessionStore = store
        
        sharedSessionStore.roomModel = self
        sharedSessionStore.assign(sessionStore: store)
    }
}

extension HMSRoomModel: HMSPreviewListener {
    
    @MainActor public func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {
        assign(room: room)
        localTracks.forEach {
            if $0 is HMSAudioTrack {
                previewAudioTrack = HMSTrackModel(track: $0, peerModel: nil)
            }
            if $0 is HMSVideoTrack {
                previewVideoTrack = HMSTrackModel(track: $0, peerModel: nil)
            }
        }
        
        updateStreamingState()
    }
}
