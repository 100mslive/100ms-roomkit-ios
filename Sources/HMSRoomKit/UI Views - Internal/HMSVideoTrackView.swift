//
//  HMSVideoTrackView.swift
//  HMSUIKit
//
//  Created by Pawan Dixit on 05/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

public struct HMSVideoTrackView: View {
    
    @ObservedObject public var trackModel: HMSTrackModel
    
    public var contentMode: UIView.ContentMode = .scaleAspectFill
    public var isZoomAndPanEnabled = false
    public var isDegraded = false
    
    public init(trackModel: HMSTrackModel, contentMode: UIView.ContentMode = .scaleAspectFill, isZoomAndPanEnabled: Bool = false, isDegraded: Bool = false) {
        self.trackModel = trackModel
        self.contentMode = contentMode
        self.isZoomAndPanEnabled = isZoomAndPanEnabled
        self.isDegraded = isDegraded
    }
    
    public var body: some View {
        Group {
#if !Preview
            if let videoTrack = trackModel.track as? HMSVideoTrack, !trackModel.isMute {
                HMSVideoViewRepresentable(track: videoTrack, contentMode: contentMode, isZoomAndPanEnabled: isZoomAndPanEnabled)
            }
#else
            Rectangle().foregroundStyle(.red)
#endif
        }
        .overlay {
            if isDegraded {
                Rectangle()
                .foregroundStyle(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .overlay {
                    VStack(spacing: 4) {
                        Text("Poor connection")
                            .foreground(.onSurfaceHigh)
                            .multilineTextAlignment(.center)
                            .font(.subtitle2Semibold14)
                        Text("The video will resume automatically when the connection improves")
                            .multilineTextAlignment(.center)
                            .font(.captionRegular12)
                            .foreground(.onSurfaceHigh)
                            .frame(width: 180)
                    }
                }
            }
        }
    }
}

struct HMSVideoTrackView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSVideoTrackView(trackModel: HMSTrackModel(), isDegraded: true)
            .environmentObject(HMSUITheme())
#endif
    }
}
