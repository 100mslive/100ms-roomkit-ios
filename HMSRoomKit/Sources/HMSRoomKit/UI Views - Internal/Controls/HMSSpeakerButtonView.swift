//
//  HMSGearButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import AVKit

struct HMSSpeakerButtonView: View {
    
    var body: some View {
        Image(assetName: "speaker")
            .frame(width: 40, height: 40)
            .controlAppearance(isEnabled: true)
            .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
    }
}

struct HMSSpeakerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HMSSpeakerButtonView()
            .environmentObject(HMSUITheme())
    }
}
