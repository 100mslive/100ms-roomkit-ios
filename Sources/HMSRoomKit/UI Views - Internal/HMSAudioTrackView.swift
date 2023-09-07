//
//  HMSVideoTrackView.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 05/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
@_implementationOnly import Lottie
import HMSRoomModels

struct HMSAudioTrackView: View {
    enum ButtonStyle {
        case tile
        case list
    }
    
    @EnvironmentObject var peerModel: HMSPeerModel
    @ObservedObject var trackModel: HMSTrackModel
    var style: ButtonStyle = .tile
    
    var body: some View {
        
        if trackModel.isMute {
            switch style {
            case .tile:
                Circle()
                    .foreground(.secondaryDim)
                    .overlay {
                        Image(assetName: "mic.slash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foreground(.errorBrighter)
                            .frame(width: 16, height: 16)
                    }
                    .frame(width: 32, height: 32)
                
            case .list:
                Circle()
                    .foreground(.secondaryDim)
                    .overlay {
                        Image(assetName: "mic.slash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foreground(.errorBrighter)
                            .frame(width: 16, height: 16)
                    }
                    .frame(width: 24, height: 24)
            }
        }
        else {
            HMSAudioLevelsView(peerModel: peerModel)
        }
    }
}

struct HMSAudioTrackView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSAudioTrackView(trackModel: HMSTrackModel())
            .environmentObject(HMSUITheme())
            .environmentObject(HMSPeerModel())
#endif
    }
}


struct LottieView: UIViewRepresentable {
    var animationName: String
    var loopMode: LottieLoopMode = .playOnce
    var contentMode: UIView.ContentMode = .scaleAspectFit
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        uiView.subviews.forEach({ $0.removeFromSuperview() })
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        
        animationView.animation = LottieAnimation.named(animationName, bundle: .module)
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.play()
    }
}
