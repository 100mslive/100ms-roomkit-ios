//
//  HMSShareScreenButton.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 05/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import AVKit

struct HMSAirplayButton<Content>: View where Content : View {
    
    let routePickerView: AVRoutePickerView
    
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        routePickerView = AVRoutePickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    var body: some View {
        content()
        .background(Color.black.opacity(0.0001))
        .onTapGesture {
            for subview in routePickerView.subviews {
                if let button = subview as? UIButton {
                    button.sendActions(for: UIControl.Event.allTouchEvents)
                }
            }
        }
    }
}

struct HMSAirplayButton_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSAirplayButton {
            Text("Button")
        }
        .environmentObject(HMSUITheme())
        .environmentObject(HMSPrebuiltOptions())
#endif
    }
}

struct AirPlayView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {

        let routePickerView = AVRoutePickerView()
        routePickerView.backgroundColor = UIColor.clear
        routePickerView.activeTintColor = UIColor.red
        routePickerView.tintColor = UIColor.white

        return routePickerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
