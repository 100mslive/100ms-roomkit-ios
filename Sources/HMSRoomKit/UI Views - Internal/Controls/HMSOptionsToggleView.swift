//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSOptionsToggleView: View {
    
    var body: some View {
        Image(assetName: "hamburger")
            .frame(width: 40, height: 40)
            .controlAppearance(isEnabled: true)
    }
}

struct HMSOptionsToggleView_Previews: PreviewProvider {
    static var previews: some View {
        HMSOptionsToggleView()
            .environmentObject(HMSUITheme())
    }
}
