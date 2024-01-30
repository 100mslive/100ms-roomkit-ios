//
//  SwiftUIView.swift
//
//
//  Created by Pawan Dixit on 12/11/23.
//

import SwiftUI
import HMSHLSPlayerSDK
import HMSRoomModels

struct HMSHLSPlayerControlsView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var roomModel: HMSRoomModel
    
    let player: HMSHLSPlayer
    
    @State private var isPopoverPresented = false
    
    //    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var refresh = false
    
    @Binding var isMaximized: Bool
    
    @State var isSubtitlesOff = false
    @State var isSubtitleToggleShown = false
    
    @Environment(\.hlsPlayerPreferences) var hlsPlayerPreferences
    
    var body: some View {
        Color.clear
            .sheet(isPresented: $isPopoverPresented) {
                HMSSheet {
                    HMSHLSQualityPickerView(player: player)
                }
                .edgesIgnoringSafeArea(.all)
            }
            .overlay {
                Color.clear
                    .overlay(alignment: .bottomTrailing) {
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
                        .padding(.bottom, 8)
                        .padding(.trailing, 12)
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
                    .opacity(hlsPlayerPreferences.isControlsHidden.wrappedValue ? 0.0 : 1.0)
                    .overlay(alignment: .topLeading) {
                        if !isMaximized {
                            HMSEndCallButton(type: .hls)
                                .padding(.top, 8)
                                .padding(.leading, 12)
                        }
                    }
            }
            .onAppear() {
                let player = player._nativePlayer
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
