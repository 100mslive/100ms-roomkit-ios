//
//  HMSGearButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSWifiSignalView0: View {
    
    var body: some View {
        ZStack {
            Image(assetName: "wifi\(4)")
                .foreground(.secondaryDisabled)
            
            Image(assetName: "wifi\(0)")
                .foreground(.errorDefault)
        }
    }
}

struct HMSWifiSignalView0_Previews: PreviewProvider {
    static var previews: some View {
        HMSWifiSignalView0()
            .environmentObject(HMSUITheme())
    }
}

