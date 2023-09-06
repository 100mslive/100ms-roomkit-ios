//
//  HMSMicToggle.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSCompanyLogoView: View {
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var body: some View {
#if !Preview
        if let logoUrl = currentTheme.logoURL {
            HMSAsyncImage(url: logoUrl)
        }
#else
        HMSAsyncImage(url: URL(string: "https://picsum.photos/200")!)
#endif
    }
}

struct HMSCompanyLogoView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSCompanyLogoView()
            .environmentObject(HMSUITheme())
#endif
    }
}
