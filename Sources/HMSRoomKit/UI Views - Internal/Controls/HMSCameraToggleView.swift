//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSCameraToggleView: View {
    
    let isMute: Bool
    
    var body: some View {
        Image(assetName: isMute ? "video.slash": "video")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct HMSCameraToggleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HMSCameraToggleView(isMute: true)
                .environmentObject(HMSUITheme())
            HMSCameraToggleView(isMute: false)
                .environmentObject(HMSUITheme())
        }
    }
}
