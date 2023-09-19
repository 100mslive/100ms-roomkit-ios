//
//  HMSPermissionDenialScreen.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 28/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import AVKit
import Combine

public extension View {
    func checkAccessibility(interval: TimeInterval, denial: Binding<Bool>) -> some View {
        self.modifier( AccessibilityCheckMod(interval: interval, denial: denial) )
    }
}

public struct AccessibilityCheckMod: ViewModifier {
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var denial: Bool
    
    init(interval: TimeInterval, denial: Binding<Bool>) {
        self.timer = Timer.publish(every: interval, on: .current, in: .common).autoconnect()
        _denial = denial
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(timer) { _ in
                let micAccess = AVCaptureDevice.authorizationStatus(for: .audio)
                let cameraAccess = AVCaptureDevice.authorizationStatus(for: .video)
                
                if cameraAccess == .denied || micAccess == .denied {
                    self.denial = true
                }
            }
    }
}

struct HMSPermissionDenialScreen: View {
    var body: some View {
        
        VStack(spacing: 16) {
            
            Spacer()
            
            Image(assetName: "permission-lock-icon", renderingMode: .original)
            
            Text("Enable permissions")
                .font(.heading5Semibold24)
            
            Text("Sharing your camera and microphone permissions helps us give you the optimal experience")
                .font(.body2Regular14)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text("Grant Permissions")
                .font(.buttonSemibold16)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(.primaryDefault, cornerRadius: 8)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                
        }
        .padding(.horizontal)
        .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
        // PAWANTODO: change this once design has color token
        .foreground(.onPrimaryHigh)
    }
}


struct HMSPermissionDenialScreen_Previews: PreviewProvider {
    
    static var previews: some View {
#if Preview
        HMSPermissionDenialScreen()
            .environmentObject(HMSUITheme())
#endif
    }
}
