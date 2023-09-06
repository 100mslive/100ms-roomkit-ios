//
//  HMSGearButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSBackButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .foreground(.surfaceDefault)
            Image(systemName: "chevron.left")
                .foreground(.onSurfaceHigh)
        }
        .frame(width: 40, height: 40)
    }
}

struct HMSBackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HMSBackButtonView()
            .environmentObject(HMSUITheme())
    }
}
