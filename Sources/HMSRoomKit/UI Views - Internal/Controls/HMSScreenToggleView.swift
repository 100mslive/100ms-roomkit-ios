//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSScreenToggleView: View {
    
    var body: some View {
        Image(assetName: "screenshare-icon")
            .frame(width: 40, height: 40)
            .controlAppearance(isEnabled: true)
    }
}

struct HMSScreenToggleView_Previews: PreviewProvider {
    static var previews: some View {
        HMSScreenToggleView()
            .environmentObject(HMSUITheme())
    }
}
