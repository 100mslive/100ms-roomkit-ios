//
//  HMSAudioLevelsView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 29/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
@_implementationOnly import Lottie
import HMSRoomModels

struct HMSAudioLevelsView: View {
    
    enum Activity {
        case none
        case wasSpeaking
    }
    
    @ObservedObject var peerModel: HMSPeerModel
    
    @State var state: Activity = .none
    
    var body: some View {
        VStack {
            if peerModel.isSpeaking {
                Circle()
                    .foreground(.secondaryDim)
                    .overlay {
                        LottieView(animationName: "audio-level-white",
                                   loopMode: .loop,
                                   contentMode: .scaleAspectFit)
                    }
                    .frame(width: 32, height: 32)
                    .onDisappear() {
                        state = .wasSpeaking
                    }
            }
            else {
                if state == .wasSpeaking {
                    Circle()
                        .foreground(.secondaryDim)
                        .overlay {
                            Image(systemName: "ellipsis")
                                .renderingMode(.template)
                                .foreground(.onSecondaryHigh)
                        }
                        .frame(width: 32, height: 32)
                        .task {
                            try? await Task.sleep(nanoseconds: 5_000_000_000)
                            state = .none
                        }
                }
            }
        }
    }
}

struct HMSAudioLevelsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        
        let peerModel = HMSPeerModel()
        
        VStack {
            Button {
                peerModel.isSpeaking.toggle()
            } label: {
                Text("speak")
            }
            
            HMSAudioLevelsView(peerModel: peerModel)
                .environmentObject(HMSUITheme())
        }
#endif
    }
}
