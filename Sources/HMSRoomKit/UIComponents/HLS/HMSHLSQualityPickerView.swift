//
//  HMSHLSQualityPickerView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 12/11/23.
//

import SwiftUI
import HMSHLSPlayerSDK

extension EnvironmentValues {
    var hlsPlaybackQuality: Binding<HMSHLSQualityPickerView.Quality> {
        get { self[HMSHLSQualityPickerView.Quality.Key.self] }
        set { self[HMSHLSQualityPickerView.Quality.Key.self] = newValue }
    }
}

struct HMSHLSQualityPickerView: View {
    
    enum Quality: String {
        case Auto, High, Medium, Low
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<Quality> = .constant(.Auto)
        }
    }
    
    @Environment(\.hlsPlaybackQuality) var hlsPlaybackQuality
    
    @Environment(\.dismiss) var dismiss
    
    let player: HMSHLSPlayer

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HMSOptionsHeaderView(title: "Quality") {
                dismiss()
            } onBack: {}
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    Text(Quality.Auto.rawValue)
                        .foreground(.onSurfaceHigh)
                        .font(.subtitle2Semibold14)
                        .padding(16)
                    
                    Spacer()
                    
                    if hlsPlaybackQuality.wrappedValue == .Auto {
                        Image(assetName: "checkmark")
                    }
                }
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    player._nativePlayer.currentItem?.preferredPeakBitRate = 0
                    hlsPlaybackQuality.wrappedValue = .Auto
                    dismiss()
                }
                
                HStack {
                    Text(Quality.High.rawValue)
                        .foreground(.onSurfaceHigh)
                        .font(.subtitle2Semibold14)
                        .padding(16)
                        
                    Spacer()
                    
                    if hlsPlaybackQuality.wrappedValue == .High {
                        Image(assetName: "checkmark")
                    }
                }
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    player._nativePlayer.currentItem?.preferredPeakBitRate = 1500 * 1000
                    hlsPlaybackQuality.wrappedValue = .High
                    dismiss()
                }
                
                HStack {
                    Text(Quality.Medium.rawValue)
                        .foreground(.onSurfaceHigh)
                        .font(.subtitle2Semibold14)
                        .padding(16)
                        
                    Spacer()
                    
                    if hlsPlaybackQuality.wrappedValue == .Medium {
                        Image(assetName: "checkmark")
                    }
                }
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    player._nativePlayer.currentItem?.preferredPeakBitRate = 850 * 1000
                    hlsPlaybackQuality.wrappedValue = .Medium
                    dismiss()
                }
                
                HStack {
                    Text(Quality.Low.rawValue)
                        .foreground(.onSurfaceHigh)
                        .font(.subtitle2Semibold14)
                        .padding(16)
                        
                    Spacer()
                    
                    if hlsPlaybackQuality.wrappedValue == .Low {
                        Image(assetName: "checkmark")
                    }
                }
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    player._nativePlayer.currentItem?.preferredPeakBitRate = 450 * 1000
                    hlsPlaybackQuality.wrappedValue = .Low
                    dismiss()
                }
            }
        }
        .background(.surfaceDefault, cornerRadius: 8, ignoringEdges: .all)
    }
}

struct HMSHLSQualityPickerView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSQualityPickerView(player: HMSHLSPlayer())
            .environmentObject(HMSUITheme())
            .environment(\.colorScheme, .dark)
#endif
    }
}
