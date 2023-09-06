//
//  HMSRoomModel+LocalUserActions.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 06/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK

// Local user actions
@MainActor
extension HMSRoomModel {
    
    // Mic and camera
    public func toggleMic() {
#if !Preview
        Task {
            if let previewAudioTrack = previewAudioTrack {
                try await previewAudioTrack.toggleMute()
            }
            else {
                try await localAudioTrackModel?.toggleMute()
            }
            
            updateLocalMuteState()
        }
#endif
    }
    public func toggleCamera() {
#if !Preview
        Task {
            if let previewVideoTrack = previewVideoTrack {
                try await previewVideoTrack.toggleMute()
            }
            else {
                try await localVideoTrackModel?.toggleMute()
            }
            
            updateLocalMuteState()
        }
#endif
    }
    
    // Leave call
    public func leave() async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            
            sdk.leave() { [weak self] success, error in
                
                guard let self else { return }
                
                guard success else {
                    //PAWANTODO: what error to pass by default
                    continuation.resume(throwing: error ?? NSError());
                    return
                }
                self.roomState = .leave(reason: .userLeft)
                continuation.resume()
            }
        }
#endif
    }
    
    // End session
    public func endSession() async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            
            sdk.endRoom(reason: "") { [weak self] success, error in
                
                guard let self else { return }
                
                guard success else {
                    //PAWANTODO: what error to pass by default
                    continuation.resume(throwing: error ?? NSError());
                    return
                }
                
                self.roomState = .leave(reason: .roomEnded)
                continuation.resume()
            }
        }
#endif
    }
    
    // Switch camera
    public func switchCamera() {
#if !Preview
        (localVideoTrackModel?.track as? HMSLocalVideoTrack)?.switchCamera()
#endif
    }
    
    // Mute remote track
    public func changeTrackMuteState(for trackModel: HMSTrackModel, mute: Bool) async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            
            sdk.changeTrackState(for: trackModel.track, mute: mute) { success, error in
                guard success else {
                    //PAWANTODO: what error to pass by default
                    continuation.resume(throwing: error ?? NSError());
                    return
                }
                
                continuation.resume()
            }
        }
#endif
    }
    
    // Kick peer out of meeting
    public func remove(peer peerModel: HMSPeerModel) {
#if !Preview
        sdk.removePeer(peerModel.peer, reason: "")
#endif
    }
    
    // Send message
    public func send(message: String, type: String = "chat", recipient: HMSRecipient) async throws {
        
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            
            let sendCompletion: ((HMSMessage?, Error?) -> Void) = { [weak self] newMessage, error in
                guard let self else { return }
                
                guard let newMessage = newMessage else {
                    //PAWANTODO: what error to pass by default
                    continuation.resume(throwing: error ?? NSError());
                    return
                }
                
                self.messages.append(newMessage)
                continuation.resume()
            }
            
            switch recipient {
            case .everyone:
                sdk.sendBroadcastMessage(type: type, message: message, completion: sendCompletion)
            case .role(let role):
                sdk.sendGroupMessage(type: type, message: message, roles: [role], completion: sendCompletion)
            case .peer(let peer):
                sdk.sendDirectMessage(type: type, message: message, peer: peer, completion: sendCompletion)
            }
        }
#endif
    }
    
#if !Preview
    public func switchAudioOutput(to device: HMSAudioOutputDevice) throws {

        try sdk.switchAudioOutput(to: device)
    }
#endif
    
    public func startStreaming() async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            sdk.startHLSStreaming() { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func stopStreaming() async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            sdk.stopHLSStreaming() { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func startRecording() async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            sdk.startRTMPOrRecording(config: HMSRTMPConfig(meetingURL: nil, rtmpURLs: nil, record: true)) { [weak self] _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    if let self = self, self.recordingState == .stopped {
                        self.recordingState = .initializing
                    }
                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func stopRecording() async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            sdk.stopRTMPAndRecording() { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func changeUserName(_ name: String) async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            sdk.change(name: name) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func setUserMetadata(_ metadata: String) async throws {
#if !Preview
        return try await withCheckedThrowingContinuation { continuation in
            sdk.change(metadata: metadata) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func changeRole(of peer: HMSPeerModel, to role: String, force: Bool = false) async throws {
#if !Preview
        guard let destinationRole = roles.first(where: { $0.name == role }) else { return }
        
        return try await withCheckedThrowingContinuation { continuation in
            sdk.changeRole(for: peer.peer, to: destinationRole, force: force) {_, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func previewChangeRoleRequest() async throws {
#if !Preview
        guard let request = roleChangeRequests.first else { return }
        
        return try await withCheckedThrowingContinuation { continuation in
            sdk.preview(role: request.suggestedRole) { [weak self] tracks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    tracks?.forEach {
                        if $0 is HMSAudioTrack {
                            self?.previewAudioTrack = HMSTrackModel(track: $0, peerModel: nil)
                        }
                        if $0 is HMSVideoTrack {
                            self?.previewVideoTrack = HMSTrackModel(track: $0, peerModel: nil)
                        }
                    }
                    
                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func acceptChangeRoleRequest() async throws {
#if !Preview
        guard let request = roleChangeRequests.first else { return }
        
        return try await withCheckedThrowingContinuation { continuation in
            sdk.accept(changeRole: request) { [weak self] _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    self?.roleChangeRequests.removeFirst()
                    self?.previewAudioTrack = nil
                    self?.previewVideoTrack = nil

                    continuation.resume()
                }
            }
        }
#endif
    }
    
    public func declineChangeRoleRequest() async throws {
#if !Preview
        guard let request = roleChangeRequests.first else { return }
        previewAudioTrack = nil
        previewVideoTrack = nil
        sdk.cancelPreview()
        
        roleChangeRequests.removeFirst()
#endif
    }
}
