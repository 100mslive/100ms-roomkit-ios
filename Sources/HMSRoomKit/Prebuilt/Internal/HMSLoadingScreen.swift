//
//  HMSLoadingScreen.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 30/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSLoadingScreen: View {
    
    var body: some View {
        HMSLoadingView {
            Image(assetName: "progress-indicator")
                .foreground(.primaryDefault)
        }
    }
}

struct HMSLoadingView<Content>: View where Content : View {
    
    @State private var isRotating = false
    
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isRotating = true
                }
            }
    }
}

struct HMSLoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        HMSLoadingScreen()
    }
}
