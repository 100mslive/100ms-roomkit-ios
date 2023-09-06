//
//  HMSDivider.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSDivider: View {
    let color: Color
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct HMSDivider_Previews: PreviewProvider {
    static var previews: some View {
        HMSDivider(color: .red)
    }
}
