//
//  HMSPeerOptionsView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 05/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

struct HMSPeerVolumeOptionView: View {
    @ObservedObject var regularAudioTrackModel: HMSTrackModel
    @State private var renderVolume: Double = 1.0
    
    var body: some View {
        return AnyView(
            VStack(alignment: .leading) {
                
                HStack {
                    Image(assetName: "speaker")
                        .resizable()
                        .frame(width: 20, height: 20)

                    Text("Volume")
                }
                Slider(value: $renderVolume, in: 0.01...1) { _ in
                    // Empty closure, as we only want to read the value of the slider
                }
                .onChange(of: renderVolume) { newValue in
                    // Update the volume when the slider value changes
#if !Preview
                    (regularAudioTrackModel.track as? HMSRemoteAudioTrack)?.setVolume(newValue)
#endif
                }.padding(.horizontal, 29)
            }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .onAppear() {
#if !Preview
                    let volume = 1.0//(regularAudioTrackModel.track as? HMSRemoteAudioTrack)?.volume() ?? 0.0
                    renderVolume = volume == 0 ? 1.0 : volume
#endif
                }
        )
    }
}

struct HMSPeerVolumeOptionView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        @State var volume = 0.0
        
        HMSPeerVolumeOptionView(regularAudioTrackModel: .init())
#endif
    }
}
