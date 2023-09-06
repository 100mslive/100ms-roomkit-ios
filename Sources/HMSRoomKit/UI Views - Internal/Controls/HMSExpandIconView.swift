//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSExpandIconView: View {
    
    var body: some View {
        Image(assetName: "expand-icon")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct HMSExpandIconView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HMSExpandIconView()
                .environmentObject(HMSUITheme())
        }
    }
}
