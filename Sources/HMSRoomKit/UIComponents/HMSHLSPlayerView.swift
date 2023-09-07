//
//  HMSHLSPlayerView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 27/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
import HMSHLSPlayerSDK
#endif
import HMSRoomModels

import AVKit

@MainActor
class AVPlayerModel {
    static let shared = AVPlayerModel()
    weak var currentAVPlayerInstance: AVPlayerViewController?
    
    deinit {
        print("pawan: AVPlayerModel deinit")
    }
}

extension AVPlayerViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.showsPlaybackControls = false
        self.allowsPictureInPicturePlayback = true
        self.canStartPictureInPictureAutomaticallyFromInline = true
        self.videoGravity = .resizeAspectFill
        AVPlayerModel.shared.currentAVPlayerInstance = self
    }
}

public struct HMSHLSPlayerView<VideoOverlay> : View where VideoOverlay : View {
    
#if !Preview
    class Coordinator: HMSHLSPlayerDelegate, ObservableObject {
        
        let player = HMSHLSPlayer()
        
        deinit {
            print("pawan: Coordinator deinit")
        }
        
        init() {
            player.delegate = self
            player._nativePlayer.audiovisualBackgroundPlaybackPolicy = .continuesIfPossible
        }
        
        var onCue: ((HMSHLSCue)->Void)?
        var onPlaybackFailure: ((Error)->Void)?
        var onPlaybackStateChanged: ((HMSHLSPlaybackState)->Void)?
        var onResolutionChanged: ((CGSize)->Void)?
        
        func onCue(cue: HMSHLSCue) {
            onCue?(cue)
        }
        func onPlaybackFailure(error: Error) {
            onPlaybackFailure?(error)
        }
        func onPlaybackStateChanged(state: HMSHLSPlaybackState) {
            onPlaybackStateChanged?(state)
        }
        func onResolutionChanged(videoSize: CGSize) {
            onResolutionChanged?(videoSize)
            Task { @MainActor in
                if videoSize.width > videoSize.height {
                    AVPlayerModel.shared.currentAVPlayerInstance?.videoGravity = .resizeAspect
                }
                else {
                    AVPlayerModel.shared.currentAVPlayerInstance?.videoGravity = .resizeAspectFill
                }
            }
        }
    }
#else
    class Coordinator: ObservableObject {
        let player = AVPlayer(url: URL(string: "https://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8")!)
    }
    
#endif
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @StateObject var coordinator = Coordinator()
    
#if !Preview
    @ViewBuilder let videoOverlay: ((HMSHLSPlayer) -> VideoOverlay)?
    public init(@ViewBuilder videoOverlay: @escaping (HMSHLSPlayer) -> VideoOverlay) {
        self.videoOverlay = videoOverlay
    }
#endif
    
    public var body: some View {
#if !Preview
        if let url = roomModel.hlsVariants.first?.url {
            videoView(url: url)
        }
        else {
            HMSStreamNotStartedView()
        }
#else
        if let url = URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8") {
            videoView(url: url)
        }
        else {
            HMSStreamNotStartedView()
        }
#endif
    }
    
    func videoView(url: URL) -> some View {
#if !Preview
        VideoPlayer(player: coordinator.player._nativePlayer, videoOverlay: {
            videoOverlay?(coordinator.player)
        })
        .onAppear() {
            coordinator.player.play(url)
        }
        .onDisappear() {
            coordinator.player.stop()
        }

        .onChange(of: roomModel.hlsVariants) { variant in
            coordinator.player.play(url)
        }
#else
        VideoPlayer(player: coordinator.player)
            .onAppear() {
                coordinator.player.play()
            }
#endif
    }
    
#if !Preview
    public func onCue(cue: @escaping (HMSHLSCue)->Void) -> HMSHLSPlayerView {
        coordinator.onCue = { value in
            cue(value)
        }
        return self
    }
    public func onPlaybackFailure(error: @escaping (Error)->Void) -> HMSHLSPlayerView {
        coordinator.onPlaybackFailure = { value in
            error(value)
        }
        return self
    }
    public func onPlaybackStateChanged(state: @escaping (HMSHLSPlaybackState)->Void) -> HMSHLSPlayerView {
        coordinator.onPlaybackStateChanged = { value in
            state(value)
        }
        return self
    }
    public func onResolutionChanged(videoSize: @escaping (CGSize)->Void) -> HMSHLSPlayerView {
        coordinator.onResolutionChanged = { value in
            videoSize(value)
        }
        return self
    }
#endif
}

extension HMSHLSPlayerView where VideoOverlay == EmptyView {
    public init() {
#if !Preview
        videoOverlay = nil
#endif
    }
}

struct HMSHLSPlayerView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSPlayerView()
            .environmentObject(HMSUITheme())
#endif
    }
}
