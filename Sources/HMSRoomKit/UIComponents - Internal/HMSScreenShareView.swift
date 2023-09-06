////
////  HMSScreenShareExpandedView.swift
////  HMSSDK
////
////  Created by Pawan Dixit on 22/06/2023.
////  Copyright © 2023 100ms. All rights reserved.
////
//
//import SwiftUI
//#if !Preview
//import HMSSDK
//#endif
//import ReplayKit
//
//struct HMSScreenShareView: View {
//    
//    @EnvironmentObject var options: HMSPrebuiltOptions
//    
//    let prominentPeer: HMSPeerModel
//    let broadcastPickerView: RPSystemBroadcastPickerView
//    
//    init(prominentPeer: HMSPeerModel) {
//        self.prominentPeer = prominentPeer
//        
//        broadcastPickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        broadcastPickerView.showsMicrophoneButton = false
//    }
//    
//    
//    var body: some View {
//        
//#if !Preview
//        let isLocal = prominentPeer.peer.isLocal
//#else
//        let isLocal = false
//#endif
//        
//        Group {
//            if isLocal {
//                HMSLocalScreenShareView()
//                    .onTapGesture {
//#if !Preview
//                        for subview in broadcastPickerView.subviews {
//                            if let button = subview as? UIButton {
//                                button.sendActions(for: UIControl.Event.allTouchEvents)
//                            }
//                        }
//#endif
//                    }
//            }
//            else {
//                HMSPeerScreenTile(peerModel: prominentPeer)
//            }
//        }
//        
//#if !Preview
//        .environmentObject(prominentPeer)
//#endif
//        .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
//        
//        .onAppear() {
//            broadcastPickerView.preferredExtension = options.preferredExtensionName
//        }
//    }
//}
//
//struct HMSScreenShareView_Previews: PreviewProvider {
//    static var previews: some View {
//#if Preview
//        HMSScreenShareView(prominentPeer: HMSPeerModel())
//            .environmentObject(HMSUITheme())
//            .environmentObject(HMSPrebuiltOptions())
//#endif
//    }
//}
