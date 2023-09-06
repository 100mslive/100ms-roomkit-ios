////
////  HMSPeerLayout.swift
////  HMSSDK
////
////  Created by Pawan Dixit on 26/07/2023.
////  Copyright © 2023 100ms. All rights reserved.
////
//
//import SwiftUI
//import AVKit
//#if !Preview
//import HMSSDK
//#endif
//
//struct HMSPeerLayout: View {
//    
//    @EnvironmentObject var roomModel: HMSRoomModel
//    @Environment(\.menuContext) var menuContext
//    
//    var body: some View {
//        
//#if !Preview
//        let isHLSViewer = roomModel.userRole?.name.hasPrefix("hls-") ?? false
//#else
//        let isHLSViewer = false
//#endif
//        
//        if isHLSViewer {
//#if !Preview
//            HMSHLSPlayerView() { player in
//                Button {
//                    player.pause()
//                } label: {
//                    Text("Pause")
//                }
//                
//                Button {
//                    player.resume()
//                } label: {
//                    Text("Resume")
//                }
//            }
//            .onResolutionChanged() { size in
//                print("pawan: onResolutionChanged \(size)")
//            }
//            .onPlaybackFailure() { error in
//                print("pawan: onPlaybackFailure \(error)")
//            }
//            .onAppear() {
//                menuContext.wrappedValue = .opaque
//            }
//            .onDisappear() {
//                menuContext.wrappedValue = .none
//            }
//#endif
//        }
//        else {
//            
//        }
//    }
//}
//
//
//struct HMSPeerLayout_Previews: PreviewProvider {
//    static var previews: some View {
//#if Preview
//        HMSPeerLayout()
//            .environmentObject(HMSRoomModel.dummyRoom(3))
//            .environmentObject(HMSUITheme())
//#endif
//    }
//}
