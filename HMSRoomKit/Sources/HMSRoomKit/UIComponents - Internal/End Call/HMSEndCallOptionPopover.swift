////
////  HMSEndCallOptionPopover.swift
////  HMSSDK
////
////  Created by Pawan Dixit on 11/07/2023.
////  Copyright © 2023 100ms. All rights reserved.
////
//
//import SwiftUI
//
//struct HMSEndCallOptionPopover: View {
//    
//    @Environment(\.leaveContext) var leaveContext
//    
//    @EnvironmentObject var roomModel: HMSRoomModel
//    
//    @Binding var isPresented: Bool
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack(alignment: .top, spacing: 16) {
//                Image(assetName: "leave-icon")
//                    .foreground(.onSurfaceHigh)
//                    .frame(width: 24, height: 24)
//                
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Leave")
//                        .foreground(.onSurfaceHigh)
//                        .font(.heading6Semibold20)
//                    
//                    Text("Others will continue after you leave. You can join the session again.")
//                        .fixedSize(horizontal: false, vertical: true)
//                        .font(.body2Regular14)
//                        .foreground(.onSurfaceLow)
//                }
//                Spacer()
//            }
//            .padding(24)
//            .background(.surfaceDim, cornerRadius: 0)
//            .onTapGesture {
//                isPresented = false
//            }
//            
//            HStack(alignment: .top, spacing: 16) {
//                Image(assetName: "warning-icon")
//                    .frame(width: 24, height: 24)
//                    .foreground(.errorBrighter)
//                
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("End Session")
//                        .font(.heading6Semibold20)
//                        .foreground(.errorBrighter)
//                        
//                    
//                    Text("The session and stream will end for everyone. You can’t undo this action.")
//                        .fixedSize(horizontal: false, vertical: true)
//                        .font(.body2Regular14)
//                        .foreground(.errorBright)
//                }
//                Spacer()
//            }
//            .padding(24)
//            .background(.errorDim, cornerRadius: 0)
//            .onTapGesture {
//                isPresented = false
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//        .background(.surfaceDim, cornerRadius: 0)
//    }
//}
//
//struct HMSEndCallOptionPopover_Previews: PreviewProvider {
//    static var previews: some View {
//#if Preview
//        HMSEndCallOptionPopover(isPresented: .constant(true))
//            .environmentObject(HMSUITheme())
//#endif
//    }
//}
