//
//  SwiftUIView.swift
//
//
//  Created by Pawan Dixit on 12/11/23.
//

import SwiftUI
import HMSHLSPlayerSDK
import HMSRoomModels
import AVKit

struct HMSHLSPlayerControlsView: View {
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var roomModel: HMSRoomModel
    
    let player: HMSHLSPlayer
    
    @State private var isPopoverPresented = false
    @State private var progress: CGFloat = 1.0
    @State private var isSeeking: Bool = false
    @State var isLive: Bool = true
    @State var timeFromLive: String = ""
    @State var canShowSeekBack: Bool = false
    @State var canShowSeekForward: Bool = false
    @State var seekStartDate = Date()
    
    let seekBackSeconds: Double = 10.0
    let seekForwardSeconds: Double = 10.0
    let seekButtonDisplayTolerance: Double = 3
    let seekWindowStartPadding: Double = 1.0

    let liveLossToleranceSeconds: Double = 6
    let liveRegainToleranceSeconds: Double = 2
    
    @State private var timeObserver: Any? = nil
    @EnvironmentObject var currentTheme: HMSUITheme
    
    //    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var refresh = false
    
    @Binding var isMaximized: Bool
    @Binding var isPlaying: Bool
    
    var isSeekEnabled: Bool
    
    @State var isSubtitlesOff = false
    @State var isSubtitleToggleShown = false
    
    @Environment(\.hlsPlayerPreferences) var hlsPlayerPreferences
    
    var body: some View {
        
        let isChatEnabled = conferenceParams.chat != nil
        
        Color.clear
            .sheet(isPresented: $isPopoverPresented) {
                HMSSheet {
                    HMSHLSQualityPickerView(player: player)
                }
                .edgesIgnoringSafeArea(.all)
            }
            .overlay {
                Color.clear
                    .overlay(alignment: .bottom) {
                        HStack(alignment: .center, spacing: 8) {
                            Button() {
                                seekToLive()
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Circle()
                                        .fill(isLive ? currentTheme.colorTheme.alertErrorDefault : currentTheme.colorTheme.onSurfaceLow)
                                        .frame(width: 8, height: 8)
                                    Text(isLive ? "LIVE" : "GO LIVE")
                                        .font(.body1Semibold16)
                                        .foreground(isLive ? .onSurfaceHigh : .onSurfaceMedium)
                                }.padding(.horizontal, 4)
                            }
                            
                            Text(isLive ? "" : timeFromLive).font(.body1Regular16).foreground(.white)
                            
                            Spacer()
                            
                            if isChatEnabled {
                                Button {
                                    hlsPlayerPreferences.wrappedValue.resetHideTask?()
                                    
                                    withAnimation {
                                        isMaximized.toggle()
                                    }
                                } label: {
                                    Image(assetName: isMaximized ? "minimize-icon" : "maximize-icon")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .foreground(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, verticalSizeClass == .compact || isMaximized ?  4 : 11)
                    }
                    .overlay(alignment: .center) {
                        HStack(spacing: 24) {
                            Button {
                                hlsPlayerPreferences.wrappedValue.resetHideTask?()
                                seekBackward(seconds: seekBackSeconds)
                            } label: {
                                Image(assetName: "seek-back")
                                    .foreground(.white)
                            }.opacity(canShowSeekBack ? 1.0 : 0.0)
                            Button {
                                hlsPlayerPreferences.wrappedValue.resetHideTask?()
                                togglePlay()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(white: 0, opacity: 0.6))
                                        .frame(width: 64, height: 64)
                                    Image(assetName: isPlaying ?  "pause" : "play")
                                        .foreground(.white)
                                }
                            }
                            Button {
                                hlsPlayerPreferences.wrappedValue.resetHideTask?()
                                seekForward(seconds: seekForwardSeconds)
                            } label: {
                                Image(assetName: "seek-forward")
                                    .foreground(.white)
                            }.opacity(canShowSeekForward ? 1.0 : 0.0)
                        }.opacity(isSeekEnabled ? 1.0 : 0.0)
                    }
                    .overlay(alignment: .topTrailing) {
                        
                        HStack(spacing: 20) {
                            
                            if isSubtitleToggleShown {
                                
                                Image(assetName: isSubtitlesOff ? "subtitle-off" : "subtitle-on")
                                    .resizable()
                                    .foreground(.white)
                                    .frame(width: 32, height: 32)
                                    .onTapGesture {
                                        
                                        hlsPlayerPreferences.wrappedValue.resetHideTask?()
                                        
                                        let player = player._nativePlayer
                                        guard let playerItem = player.currentItem else {return }
                                        
                                        guard let availableSubtitleTracks = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return }
                                        
                                        // subtitle are available in media
                                        
                                        if let _ = playerItem.currentMediaSelection.selectedMediaOption(in: availableSubtitleTracks) {
                                            // subtitle is selected, remove it
                                            playerItem.select(nil, in: availableSubtitleTracks)
                                            
                                            isSubtitlesOff = true
                                        }
                                        else {
                                            // subtitle is not selected, set the first available subtitle
                                            if let firstSubtitle = availableSubtitleTracks.options.first(where: {$0.mediaType == .subtitle}) {
                                                
                                                playerItem.select(firstSubtitle, in: availableSubtitleTracks)
                                                
                                                isSubtitlesOff = false
                                            }
                                        }
                                    }
                            }
                            
                            Image(assetName: "gear-icon")
                                .resizable()
                                .foreground(.white)
                                .frame(width: 32, height: 32)
                                .onTapGesture {
                                    hlsPlayerPreferences.wrappedValue.resetHideTask?()
                                    
                                    isPopoverPresented.toggle()
                                }
                        }
                        .padding(.top, 8)
                        .padding(.trailing, 12)
                    }
                    .overlay(alignment: .bottom) {
                        HMSSeekBarView(progress: $progress).onStartProgress {
                            isSeeking = true
                            seekStartDate = Date()
                            player._nativePlayer.pause()
                            hlsPlayerPreferences.wrappedValue.resetHideTask?()
                        }.onEndProgress {
                            seek(to: progress)
                            isSeeking = false
                            hlsPlayerPreferences.wrappedValue.resetHideTask?()
                        }
                        .padding(.bottom, verticalSizeClass == .compact || isMaximized ? 40 : 0)
                        .opacity(isSeekEnabled ? 1.0 : 0.0)
                    }
                    .opacity(hlsPlayerPreferences.isControlsHidden.wrappedValue && !isSeeking ? 0.0 : 1.0)
            }
            .onAppear() {
                let player = player._nativePlayer
                
                let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
                timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsed in
                    self.updatePlayerTime()
                })
                
                guard let playerItem = player.currentItem else {
                    isSubtitleToggleShown = false
                    return
                }
                
                guard let availableSubtitleTracks = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else {
                    isSubtitleToggleShown = false
                    return
                }
                
                guard let firstOption = availableSubtitleTracks.options.first else {
                    isSubtitleToggleShown = false
                    return
                }
                
                if firstOption.mediaType == .subtitle {
                    isSubtitleToggleShown = true
                }
                else {
                    isSubtitleToggleShown = false
                }
            }
            .animation(.default, value: hlsPlayerPreferences.isControlsHidden.wrappedValue)
        //            .overlay(alignment: .bottomTrailing, content: {
        //                VStack {
        //                    if refresh {
        //                        Text("preferredPeakBitRate: \(player._nativePlayer.currentItem?.preferredPeakBitRate ?? -1)")
        //                        Text("bitrate: \(player.statMonitor.bitrate)")
        //                        Text("estimatedBandwidth: \(player.statMonitor.estimatedBandwidth)")
        //                        Text("width: \(player.statMonitor.videoSize.width), height: \(player.statMonitor.videoSize.height)")
        //                    }
        //                    else {
        //                        Text("preferredPeakBitRate: \(player._nativePlayer.currentItem?.preferredPeakBitRate ?? -1)")
        //                        Text("bitrate: \(player.statMonitor.bitrate)")
        //                        Text("estimatedBandwidth: \(player.statMonitor.estimatedBandwidth)")
        //                        Text("width: \(player.statMonitor.videoSize.width), height: \(player.statMonitor.videoSize.height)")
        //                    }
        //                }
        //                .foreground(.white)
        //            })
        //            .onReceive(timer) { _ in
        //                refresh.toggle()
        //            }

    }
    
    func togglePlay() {
        let player = player._nativePlayer
        
        isPlaying ? player.pause() : player.play()
        if !isPlaying {
            isLive = false
        }
    }
    
    func seekForward(seconds: TimeInterval) {
        let player = player._nativePlayer
        let time = CMTime(seconds: player.currentTime().seconds + seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        if time.isValid {
            player.seek(to: time) { completed in
                guard completed else { return }
                
                isLive = fabsf(Float(progress) - 1.0) <= .ulpOfOne
            }
        }
    }
    
    func seekBackward(seconds: TimeInterval) {
        let player = player._nativePlayer
        
        let time = CMTime(seconds: player.currentTime().seconds - seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        if time.isValid {
            player.seek(to: time)
        }
    }
   
    private func seekToLive() {
        let player = player._nativePlayer
        
        guard let timeRange = player.currentItem?.seekableTimeRanges.last as? CMTimeRange else { return }
        
        let start = timeRange.start.seconds
        let totalDuration = timeRange.duration.seconds
        let targetTime = CMTime(seconds: start + totalDuration,
                            preferredTimescale: 600)
         
        if targetTime.isValid {
            player.seek(to: targetTime)
        }
    }
    
    private func seek(to progress: CGFloat) {
        let player = player._nativePlayer
        
        guard let duration = player.currentItem?.duration else { return }

        
        var targetTime = CMTime(seconds: progress * duration.seconds,
                                preferredTimescale: 600)
        
        if duration.isIndefinite {
            guard let timeRange = player.currentItem?.seekableTimeRanges.last as? CMTimeRange else { return }
            
            let seekingTime = Date().timeIntervalSince(seekStartDate)
            let start = timeRange.start.seconds + seekWindowStartPadding + seekingTime
            let totalDuration = timeRange.duration.seconds
            targetTime = CMTime(seconds: start + totalDuration * progress,
                                preferredTimescale: 600)
        }
         
        player.seek(to: targetTime, completionHandler: { completed in
            if completed {
                isSeeking = false
                player.play()
            }
        })
        
    }
    
    
    private func updatePlayerTime() {
        let player = player._nativePlayer
        
        guard !isSeeking, let item = player.currentItem else { return }
        let currentTime = player.currentTime()
        let duration = item.duration
        
        if duration.isIndefinite {
            guard let timeRange = player.currentItem?.seekableTimeRanges.last as? CMTimeRange,
                    timeRange.duration.seconds > 0 else { return }
            
            let start = timeRange.start.seconds
            let totalDuration = timeRange.duration.seconds
            
            let diff = abs(start + totalDuration - currentTime.seconds)

            if isLive, diff > liveLossToleranceSeconds {
                isLive = false
            }
            
            if !isLive, diff < liveRegainToleranceSeconds {
                isLive = true
            }
            
            if !isLive {
                progress = (currentTime.seconds - start) / totalDuration
                progress = max(0.0, min(1.0, progress))
            } else {
                progress = 1.0
            }

            canShowSeekBack = (currentTime.seconds - seekBackSeconds > start)
            
            let seekForwardDiff = (start + totalDuration) - currentTime.seconds
            if canShowSeekForward, seekForwardDiff < seekForwardSeconds {
                canShowSeekForward = false
            }
            
            if !canShowSeekForward, seekForwardDiff > seekForwardSeconds + seekButtonDisplayTolerance {
                canShowSeekForward = true
            }
            
            let secondsFromLive = TimeInterval(start + totalDuration - currentTime.seconds)
            if !isLive, secondsFromLive > 0 {
                timeFromLive = "-" + secondsFromLive.stringTimeShort
            } else {
                timeFromLive = ""
            }
            
            return
        }
        
        
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        progress = CGFloat(currentTimeInSecond/durationTimeInSecond)
    }
}

struct HMSHLSPlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSPlayerControlsView(player: HMSHLSPlayer(), isMaximized: .constant(false))
            .environmentObject(HMSUITheme())
            .environment(\.colorScheme, .dark)
#endif
    }
}
