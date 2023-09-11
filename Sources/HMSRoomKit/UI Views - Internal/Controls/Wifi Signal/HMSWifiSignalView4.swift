//
//  HMSGearButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSWifiSignalView4: View {
    
    var body: some View {
        ZStack {
            Image(assetName: "wifi\(4)")
                .foreground(.secondaryDisabled)
            
            Image(assetName: "wifi\(4)")
                .foreground(.alertSuccess)
        }
    }
}

struct HMSWifiSignalView4_Previews: PreviewProvider {
    static var previews: some View {
        HMSWifiSignalView4()
            .environmentObject(HMSUITheme())
    }
}

