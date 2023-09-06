//
//  HMSGearButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSWifiSignalView: View {
    enum Style {
        case tile
        case list
    }
    
    let level: Int
    var style: Style = .tile
    
    var body: some View {
        if style == .tile {
            Group {
                if level == 1 {
                    HMSWifiSignalView1()
                }
                else if level == 2 {
                    HMSWifiSignalView2()
                }
                else if level == 3 {
                    HMSWifiSignalView3()
                }
                else if level == 4 {
                    HMSWifiSignalView4()
                }
                else {
                    HMSWifiSignalView0()
                }
            }
            .frame(width: 20, height: 20)
        } else {
            Circle()
                .foreground(.secondaryDim)
                .overlay {
                    if level == 1 {
                        HMSWifiSignalView1()
                    }
                    else if level == 2 {
                        HMSWifiSignalView2()
                    }
                    else if level == 3 {
                        HMSWifiSignalView3()
                    }
                    else if level == 4 {
                        HMSWifiSignalView4()
                    }
                    else {
                        HMSWifiSignalView0()
                    }
                }
                .frame(width: 24, height: 24)
        }
    }
}

struct HMSWifiSignalView_Previews: PreviewProvider {
    static var previews: some View {
        HMSWifiSignalView(level: 3)
            .environmentObject(HMSUITheme())
    }
}
