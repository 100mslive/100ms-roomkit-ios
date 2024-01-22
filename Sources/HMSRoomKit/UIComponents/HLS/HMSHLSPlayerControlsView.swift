//
//  SwiftUIView.swift
//  
//
//  Created by Pawan Dixit on 12/11/23.
//

import SwiftUI
import HMSHLSPlayerSDK

struct HMSHLSPlayerControlsView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let player: HMSHLSPlayer
    
    @State private var isPopoverPresented = false
    
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var refresh = false
    
    @Binding var isMaximized: Bool
    
    var body: some View {
        Color.clear
            .onReceive(NotificationCenter.default.publisher(for: .init(rawValue: "hls-quality-picker"))) { _ in
                
                isPopoverPresented.toggle()
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    withAnimation {
                        isMaximized.toggle()
                    }
                } label: {
                    Image(assetName: isMaximized ? "maximize-icon" : "minimize-icon")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foreground(.white)
                }
                .padding(.trailing, 8)
                .padding(.bottom, 4)
            }
            .overlay(alignment: .topTrailing) {
                Image(assetName: "gear-icon")
                    .resizable()
                    .foreground(.white)
                    .frame(width: 32, height: 32)
                    .padding()
                    .onTapGesture {
                        isPopoverPresented.toggle()
                    }
                    
            }
            .sheet(isPresented: $isPopoverPresented) {
                HMSSheet {
                    HMSHLSQualityPickerView(player: player)
                }
                .edgesIgnoringSafeArea(.all)
            }
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
