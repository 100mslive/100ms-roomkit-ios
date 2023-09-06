//
//  JoinbuttonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 12/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSJoinNameView: View {
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @Binding var name: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("Name", text: $name, prompt: Text("Enter Name...")
            .foregroundColor(currentTheme.colorTheme.onSurfaceLow))
            .focused($isFocused)
            .padding()
            .foreground(.onSurfaceHigh)
            .font(.body1Regular16)
            .frame(height: 48)
            .background(.surfaceDefault, cornerRadius: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(currentTheme.colorTheme.primaryDefault, lineWidth: isFocused ? 1 : 0)
            )
    }
}

struct HMSJoinNameView_Previews: PreviewProvider {
    static var previews: some View {
        HMSJoinNameView(name: .constant(""))
            .environmentObject(HMSUITheme())
    }
}
