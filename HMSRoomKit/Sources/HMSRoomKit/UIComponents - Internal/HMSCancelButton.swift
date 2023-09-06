//
//  HMSCancelButton.swift
//  HMSSDK
//
//  Created by Dmitry Fedoseyev on 21.07.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSCancelButton: View {
    var body: some View {
        Text("Cancel")
            .foreground(.errorBrighter)
            .font(.buttonSemibold16)
            .frame(width: 103, height: 48)
            .background(.errorDefault, cornerRadius: 8)
    }
}
