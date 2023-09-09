//
//  HMSShareScreenButton.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 05/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import ReplayKit
import Combine
import HMSRoomModels

extension RPSystemBroadcastPickerView: ObservableObject {}
public struct HMSShareScreenButton<Content>: View where Content : View {
    
    @EnvironmentObject var room: HMSRoomModel
    
    @StateObject var broadcastPickerView = {
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        picker.showsMicrophoneButton = false
        return picker
    }()
    
    let onTap:(()->Void)?
    @ViewBuilder let content: () -> Content
    public init(onTap:(()->Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.onTap = onTap
    }
    
    public var body: some View {
        content()
        .background(Color.black.opacity(0.0001))
        .onTapGesture {
            for subview in broadcastPickerView.subviews {
                if let button = subview as? UIButton {
                    button.sendActions(for: UIControl.Event.allTouchEvents)
                }
            }
            onTap?()
        }
        .onAppear() {
            broadcastPickerView.preferredExtension = room.options?.screenShareBroadcastExtensionBundleId
        }
    }
}

//struct HMSShareScreenButton: View {
//
//    @EnvironmentObject var options: HMSPrebuiltOptions
//
//    @StateObject var broadcastPickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//    init() {
//        broadcastPickerView.showsMicrophoneButton = false
//    }
//
//    var body: some View {
//        HMSSessionMenuButton(text: "Share Screen", image: "screenshare-icon", highlighted: false)
//        .onTapGesture {
//            for subview in broadcastPickerView.subviews {
//                if let button = subview as? UIButton {
//                    button.sendActions(for: UIControl.Event.allTouchEvents)
//                }
//            }
//        }
//        .onAppear() {
//            broadcastPickerView.preferredExtension = options.preferredExtensionName
//        }
//    }
//}

//struct HMSShareScreenButton_Previews: PreviewProvider {
//    static var previews: some View {
//#if Preview
//        HMSShareScreenButton()
//            .environmentObject(HMSUITheme())
//            .environmentObject(HMSPrebuiltOptions()).background(.black)
//#endif
//    }
//}
