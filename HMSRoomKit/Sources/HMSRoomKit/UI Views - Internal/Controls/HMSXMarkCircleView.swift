//
//  HMSGearButtonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 14/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSXMarkCircleView: View {
    var body: some View {
        ZStack {
            Circle()
                .foreground(.surfaceDefault)
            Image(systemName: "xmark")
                .imageScale(.large)
                .foreground(.onSurfaceHigh)
        }
        .frame(width: 48, height: 48)
    }
}

struct HMSXMarkView: View {
    var body: some View {
        ZStack {
            Image(systemName: "xmark")
                .imageScale(.large)
                .foreground(.onSurfaceLow)
        }
        .frame(width: 48, height: 48)
    }
}

struct HMSXMarkButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HMSXMarkCircleView()
                .environmentObject(HMSUITheme())
            HMSXMarkView()
                .environmentObject(HMSUITheme())
        }
    }
}
