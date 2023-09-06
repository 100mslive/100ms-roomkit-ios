//
//  HMSGearButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSWifiSignalView3: View {
    
    var body: some View {
        ZStack {
            Image(assetName: "wifi\(4)")
                .foreground(.secondaryDisabled)
            
            Image(assetName: "wifi\(3)")
                .foreground(.alertWarning)
        }
    }
}

struct HMSWifiSignalView3_Previews: PreviewProvider {
    static var previews: some View {
        HMSWifiSignalView3()
            .environmentObject(HMSUITheme())
    }
}

