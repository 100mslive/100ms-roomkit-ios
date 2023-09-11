//
//  HMSMicButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSMicToggleView: View {
    
    let isMute: Bool
    
    var body: some View {
        Image(assetName: isMute ? "mic.slash" : "mic")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct HMSMicToggleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HMSMicToggleView(isMute: true)
                .environmentObject(HMSUITheme())
            HMSMicToggleView(isMute: false)
                .environmentObject(HMSUITheme())
        }
    }
}

