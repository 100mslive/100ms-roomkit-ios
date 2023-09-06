//
//  HMSHLSViewerScreen.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 11/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSHLSViewerScreen: View {
    var body: some View {
        HMSHLSPlayerView()
#if !Preview
            .onResolutionChanged { size in
                print("pawan: resolution: \(size)")
            }
            .onPlaybackFailure { error in
                print("pawan: hlsError: \(error.localizedDescription)")
            }
#endif
    }
}

struct HMSHLSViewerScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSViewerScreen()
#endif
    }
}

