//
//  HMSCameraButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSHandRaisedIconView: View {
    
    var body: some View {
        Circle()
            .foreground(.secondaryDim)
            .overlay {
                Image(assetName: "hand-raise-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foreground(.onSurfaceHigh)
                    .frame(width: 25, height: 25)
            }
            .frame(width: 32, height: 32)
    }
}

struct HMSHandRaisedIconView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HMSHandRaisedIconView()
                .environmentObject(HMSUITheme())
        }
    }
}
