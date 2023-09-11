//
//  HMSVideoViewRepresentable.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 29/05/2023.
//

import SwiftUI
import HMSSDK

struct HMSVideoViewRepresentable: UIViewRepresentable {
    var track: HMSVideoTrack
    var contentMode: UIView.ContentMode
    var isZoomAndPanEnabled: Bool

    func makeUIView(context: Context) -> HMSVideoView {

        let videoView = HMSVideoView()
        videoView.setVideoTrack(track)
        videoView.videoContentMode = contentMode
        videoView.isZoomAndPanEnabled = isZoomAndPanEnabled
        return videoView
    }

    func updateUIView(_ videoView: HMSVideoView, context: Context) {}
    
    static func dismantleUIView(_ uiView: HMSVideoView, coordinator: ()) {
        uiView.setVideoTrack(nil)
    }
}
