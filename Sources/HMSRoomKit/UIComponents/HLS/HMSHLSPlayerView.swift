//
//  HMSHLSPlayerView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 27/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
#if !Preview
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
        self.allowsPictureInPicturePlayback = false
        self.canStartPictureInPictureAutomaticallyFromInline = false
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
    
    var onCue: ((HMSHLSCue)->Void)?
    var onPlaybackFailure: ((Error)->Void)?
    var onPlaybackStateChanged: ((HMSHLSPlaybackState)->Void)?
    var onResolutionChanged: ((CGSize)->Void)?
    
    @ViewBuilder let videoOverlay: ((HMSHLSPlayer) -> VideoOverlay)?
    public init(@ViewBuilder videoOverlay: @escaping (HMSHLSPlayer) -> VideoOverlay) {
        self.videoOverlay = videoOverlay
    }
#endif
    
    public var body: some View {
        Group {
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
        .onAppear() {
#if !Preview
            coordinator.onCue = onCue
            coordinator.onPlaybackFailure = onPlaybackFailure
            coordinator.onPlaybackStateChanged = onPlaybackStateChanged
            coordinator.onResolutionChanged = onResolutionChanged
#endif
        }
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
        var newView = HMSHLSPlayerView(videoOverlay: videoOverlay!)
        setupNewView(newView: &newView)
        newView.onCue = { value in
            cue(value)
        }
        return newView
    }
    public func onPlaybackFailure(error: @escaping (Error)->Void) -> HMSHLSPlayerView {
        var newView = HMSHLSPlayerView(videoOverlay: videoOverlay!)
        setupNewView(newView: &newView)
        newView.onPlaybackFailure = { value in
            error(value)
        }
        return newView
    }
    public func onPlaybackStateChanged(state: @escaping (HMSHLSPlaybackState)->Void) -> HMSHLSPlayerView {
        var newView = HMSHLSPlayerView(videoOverlay: videoOverlay!)
        setupNewView(newView: &newView)
        newView.onPlaybackStateChanged = { value in
            state(value)
        }
        return newView
    }
    public func onResolutionChanged(videoSize: @escaping (CGSize)->Void) -> HMSHLSPlayerView {
        var newView = HMSHLSPlayerView(videoOverlay: videoOverlay!)
        setupNewView(newView: &newView)
        newView.onResolutionChanged = { value in
            videoSize(value)
        }
        return newView
    }
    
    func setupNewView( newView: inout HMSHLSPlayerView) {
        
        newView.onCue = onCue
        newView.onPlaybackFailure = onPlaybackFailure
        newView.onPlaybackStateChanged = onPlaybackStateChanged
        newView.onResolutionChanged = onResolutionChanged
    }
#endif
}

extension HMSHLSPlayerView where VideoOverlay == EmptyView {
    public init() {
#if !Preview
        videoOverlay = nil
#endif
    }
    
#if !Preview
    public func onCue(cue: @escaping (HMSHLSCue)->Void) -> HMSHLSPlayerView {
        var newView = HMSHLSPlayerView()
        setupNewView(newView: &newView)
        newView.onCue = { value in
            cue(value)
        }
        return newView
    }
    public func onPlaybackFailure(error: @escaping (Error)->Void) -> HMSHLSPlayerView {
        var newView = HMSHLSPlayerView()
        setupNewView(newView: &newView)
        newView.onPlaybackFailure = { value in
            error(value)
        }
        return newView
    }
    public func onPlaybackStateChanged(state: @escaping (HMSHLSPlaybackState)->Void) -> HMSHLSPlayerView {
        var newView = HMSHLSPlayerView()
        setupNewView(newView: &newView)
        newView.onPlaybackStateChanged = { value in
            state(value)
        }
        return newView
    }
    public func onResolutionChanged(videoSize: @escaping (CGSize)->Void) -> HMSHLSPlayerView {
        var newView = HMSHLSPlayerView()
        setupNewView(newView: &newView)
        newView.onResolutionChanged = { value in
            videoSize(value)
        }
        return newView
    }
#endif
}

struct HMSHLSPlayerView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSPlayerView()
            .environmentObject(HMSUITheme())
#endif
    }
}
